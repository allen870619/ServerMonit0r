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
        Chart(connData.list) {
            LineMark(x: .value("time", $0.time),
                     y: .value("temp", $0.temp))
                .foregroundStyle(by: .value("type", "CPU Temp.(ºC)"))

            LineMark(x: .value("time", $0.time),
                     y: .value("usage", $0.cpuUsage))
                .foregroundStyle(by: .value("type", "CPU Usage(%)"))

            LineMark(x: .value("time", $0.time),
                     y: .value("usage", $0.memUsage))
                .foregroundStyle(by: .value("type", "Mem Usage(%)"))
        }
        .chartForegroundStyleScale([
            "CPU Temp.(ºC)": .red, "CPU Usage(%)": .green, "Mem Usage(%)": .blue,
        ])
        .chartXScale(domain: 1 + connData.chartDelta ... 60 + connData.chartDelta)
        .chartYScale(domain: 0 ... 105)
        .padding(32)
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    var temp: Double
    var cpuUsage: Double
    var memUsage: Double
    var time: Int
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
    }
}
