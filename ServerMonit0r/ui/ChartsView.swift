//
//  ChartsView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/14.
//

import Charts
import SwiftUI

enum ChartLineType: String, Plottable {
    case cpuTemp = "CPU Temp.(ºC)"
    case cpuUsage = "CPU Usage(%)"
    case memUsage = "Mem Usage(%)"
}

struct ChartsView: View {
    @StateObject var connData = SocketConnection.shared

    var body: some View {
        ScrollView {
            VStack {
                Chart {
                    ForEach(connData.chartData.list) { data in
                        LineMark(x: .value("time", data.time),
                                 y: .value("temp", data.temp))
                            .foregroundStyle(by: .value("type", ChartLineType.cpuTemp))

                        LineMark(x: .value("time", data.time),
                                 y: .value("usage", data.cpuUsage))
                            .foregroundStyle(by: .value("type", ChartLineType.cpuUsage))

                        LineMark(x: .value("time", data.time),
                                 y: .value("usage", data.memUsage))
                            .foregroundStyle(by: .value("type", ChartLineType.memUsage))
                    }
                }
                .frame(minHeight: 240)
                .chartForegroundStyleScale([
                    ChartLineType.cpuTemp.rawValue: .red,
                    ChartLineType.cpuUsage.rawValue: .green,
                    ChartLineType.memUsage.rawValue: .blue,
                ])
                .chartXScale(domain: connData.chartData.startDate ... connData.chartData.endDate)
                .chartYScale(domain: 0 ... 105)
                .padding(32)
            }
        }
        .background(Color.backgroundColor)
        .navigationTitle("charts".toNSL())
        .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
    }
}
