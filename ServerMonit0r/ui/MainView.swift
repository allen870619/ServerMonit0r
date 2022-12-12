//
//  MainView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var connData = SocketConnection.shared
    @State private var btnConnTitle = "connect".toNSL()

    // layout
    private let gridConfig = Array(repeating: GridItem(.adaptive(minimum: 160, maximum: 360),
                                                       alignment: .center),
                                   count: 2)

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: gridConfig) {
                    MonitorGauge(value: connData.cpuUsage,
                                 hint: "cpuUsage".toNSL(),
                                 type: .percent)
                    MonitorGauge(value: connData.cpuTemp,
                                 hint: "cpuTemp".toNSL(),
                                 type: .temp)
                    MonitorGauge(value: connData.cpuFreq,
                                 type: .freq)
                    MonitorGauge(value: connData.memUsage,
                                 hint: "memUsage".toNSL(),
                                 type: .percent)
                }
                .padding(.horizontal, 8)

                VStack {
                    CustomTextView(title: "downloadSpd".toNSL(),
                                   value: "\(connData.dlSpeed)",
                                   unit: connData.spdUnitText,
                                   minVal: 0,
                                   maxVal: 100)
                        .padding(.vertical, 16)
                    CustomTextView(title: "uploadSpd".toNSL(),
                                   value: "\(connData.ulSpeed)",
                                   unit: connData.spdUnitText,
                                   minVal: 0,
                                   maxVal: 100)
                        .padding(.vertical, 16)
                    CustomTextView(title: "uptime".toNSL(),
                                   value: connData.uptime)
                        .padding(.vertical, 16)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Server Monit0r")
            .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)

            ZStack {
                Button(action: {
                    if connData.connStatus == .connecting || connData.connStatus == .connected {
                        connData.disconnect()
                    } else {
                        connData.connect()
                    }
                }, label: {
                    Text(btnConnTitle)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.textColor)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                        .onChange(of: connData.connStatus, perform: { type in
                            switch type {
                            case .disconnect:
                                btnConnTitle = "connect".toNSL()
                            case .connecting:
                                btnConnTitle = "connecting".toNSL()
                            case .connected:
                                btnConnTitle = "disconnect".toNSL()
                            }
                        })
                })
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
            .background(Color.accentVariantColor)
        }
        .alert(connData.alertTitle, isPresented: $connData.alertIsPresented, actions: {
            Button("ok".toNSL()) {}
        }, message: {
            if let msg = connData.alertMsg {
                Text(msg)
            }
        })
        .background(Color.backgroundColor)
    }
}

/**
 text view
 */
struct CustomTextView: View {
    let title: String
    let value: String
    var unit: String?
    var minVal: Double?
    var maxVal: Double?

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.textColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(unit == nil ? "\(value)" : "\(value) \(unit ?? "")")
                .font(.system(size: 18))
                .foregroundColor(.textColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            if let minVal, let maxVal {
                CustomProgressbar(progress: progressCheck(),
                                  minValue: minVal,
                                  maxValue: maxVal)
            }
        }
    }

    func progressCheck() -> Double {
        guard let minVal, let maxVal else {
            return 0
        }
        let percent = (Double(value) ?? 0 - minVal) / (maxVal - minVal)
        if percent >= 1 {
            return 1.0
        }
        if percent <= 0 {
            return 0.0
        }
        return percent
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
