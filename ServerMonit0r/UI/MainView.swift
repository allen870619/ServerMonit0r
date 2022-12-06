//
//  MainView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var connectionData: ConnectionData
    private let verticalGridConfig = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: verticalGridConfig) {
                    MonitorGauge(value: connectionData.cpuUsage,
                                 hint: "cpuUsage".toNSL(),
                                 type: .percent)
                        .frame(maxWidth: 240)
                    MonitorGauge(value: connectionData.cpuTemp,
                                 hint: "cpuTemp".toNSL(),
                                 type: .temp)
                        .frame(maxWidth: 240)
                    MonitorGauge(value: connectionData.cpuFreq,
//                                 hint: "cpuFreq".toNSL(),
                                 type: .freq)
                        .frame(maxWidth: 240)
                    MonitorGauge(value: connectionData.memUsage,
                                 hint: "memUsage".toNSL(),
                                 type: .percent)
                        .frame(maxWidth: 240)
                }
                .padding(.horizontal, 16)

                VStack {
                    CustomTextView(title: "downloadSpd".toNSL(), value: connectionData.dlSpeed)
                        .padding(.vertical, 16)
                    CustomTextView(title: "uploadSpd".toNSL(), value: connectionData.ulSpeed)
                        .padding(.vertical, 16)
                    CustomTextView(title: "uptime".toNSL(), value: connectionData.uptime)
                        .padding(.vertical, 16)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Server Monit0r")
            .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)

            ZStack {
                Button(action: {
                    connectionData.onConnectClick()
                }, label: {
                    Text(connectionData.btnText)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.textColor)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                })
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
            .background(Color.accentVariantColor)
        }
        .alert(connectionData.alertTitle, isPresented: $connectionData.alertIsPresented, actions: {
            Button("ok".toNSL()) {}
        }, message: {
            if let msg = connectionData.alertMsg {
                Text(msg)
            }
        })
        .background(Color.backgroundColor)
    }
}

/**
 progress view
 */
struct CustomProgressView: View {
    var title: String
    var titleValue: String?
    var percent: Double

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(.textColor)
                    .multilineTextAlignment(.leading)
                    .frame(alignment: .leading)
                if let hintValue = titleValue {
                    Text(hintValue)
                        .font(.system(size: 18))
                        .foregroundColor(.textColor)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Spacer()
                }
            }
            GeometryReader { geometer in // 用來測量框架大小的
                Rectangle()
                    .frame(height: 16)
                    .foregroundColor(.accentColor)
                    .cornerRadius(8)
                    .padding(.trailing, geometer.size.width * (1 - percent))
            }
        }
    }
}

/**
 text view
 */
struct CustomTextView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.textColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .font(.system(size: 18))
                .foregroundColor(.textColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ConnectionData())
    }
}
