//
//  ChartsView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/14.
//

import Charts
import SwiftUI

struct ChartsView: View {
    @StateObject var connData = SocketConnection.shared

    var body: some View {
        ScrollView {
            VStack {
                SingleChartView(chartStyleMode: .systemInfo,
                                chartData: connData.chartViewModel.sysList)
                SingleChartView(chartStyleMode: .network,
                                chartData: connData.chartViewModel.netList,
                                needYScale: false)
            }
        }
        .background(Color.backgroundColor)
        .navigationTitle("charts".toNSL())
        .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)
        .alert(connData.alertTitle, isPresented: $connData.alertIsPresented, actions: {
            Button("ok".toNSL()) {}
        }, message: {
            if let msg = connData.alertMsg {
                Text(msg)
            }
        })
    }
}

struct SingleChartView: View {
    var chartStyleMode: ChartType
    var chartData: [ChartData]
    var needYScale = true

    var body: some View {
        let chart = Chart(chartData) { charts in
            ForEach(charts.charts) { chart in
                LineMark(x: .value("time", charts.timestamp),
                         y: .value(chart.title, chart.value))
                    .foregroundStyle(by: .value("type", chart.type.toNSL()))
            }
        }
        .frame(minHeight: 240)
        .chartForegroundStyleScale(chartStyle(type: chartStyleMode))
        .chartXScale(domain: SocketConnection.shared.chartViewModel.startDate ... SocketConnection.shared.chartViewModel.endDate)

        VStack {
            Text(chartStyleMode.rawValue.toNSL())
                .font(.system(.title3))
                .padding(.bottom, 16)
            if needYScale {
                chart.chartYScale(domain: 0 ... 105)
            } else {
                chart
            }
        }
        .padding(16)
    }

    func chartStyle(type: ChartType) -> KeyValuePairs<String, Color> {
        let color: [ChartLineType: Color] = [
            .cpuTemp: .orange,
            .cpuUsage: .blue,
            .memUsage: .green,
            .netDwByte: .red,
            .netUlByte: .purple,
        ]

        switch type {
        case .systemInfo:
            return .init(dictionaryLiteral:
                (ChartLineType.cpuTemp.toNSL(), color[.cpuTemp] ?? .black),
                (ChartLineType.cpuUsage.toNSL(), color[.cpuUsage] ?? .black),
                (ChartLineType.memUsage.toNSL(), color[.memUsage] ?? .black))
        case .network:
            return .init(dictionaryLiteral:
                (ChartLineType.netDwByte.toNSL(), color[.netDwByte] ?? .black),
                (ChartLineType.netUlByte.toNSL(), color[.netUlByte] ?? .black))
        }
    }
}

enum ChartType: String {
    case systemInfo = "systemInfoChartTitle"
    case network = "networkChartTitle"
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
    }
}
