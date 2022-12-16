//
//  SocketCharts.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/15.
//

import Charts
import Foundation
import iOSCommonUtils

class ChartViewModel: ObservableObject {
    @Published var sysList = [ChartData]()
    @Published var netList = [ChartData]()

    private let maxDataAmount = 240
    private let spaceToEnd = 8
    private(set) var startDate = Date()
    private(set) var endDate = Date()

    func appendData(data: SystemInfo) {
        let date = Date(timeIntervalSince1970: data.timestamp)

        // system
        var chartData = ChartData(timestamp: date)
        chartData.charts.append(.init(title: "temp", value: data.cpu.cpuTemp ?? 0, type: .cpuTemp))
        chartData.charts.append(.init(title: "cpuUsage", value: data.cpu.cpuUsage, type: .cpuUsage))
        chartData.charts.append(.init(title: "memUsage", value: data.mem.memUsage, type: .memUsage))
        sysList.append(chartData)

        // net
        var chartNetData = ChartData(timestamp: date)
        chartNetData.charts.append(.init(title: "dw", value: data.net.netDownload / 1024 / 1024, type: .netDwByte))
        chartNetData.charts.append(.init(title: "ul", value: data.net.netUpload / 1024 / 1024, type: .netUlByte))
        netList.append(chartNetData)

        // domain initial
        if sysList.count == 1 {
            startDate = date
        }

        // chart domain auto shift
        if sysList.count > maxDataAmount {
            sysList.removeFirst()
            netList.removeFirst()
            startDate = sysList.first?.timestamp ?? Date()
        }
        endDate = date.addingTimeInterval(TimeInterval(spaceToEnd + maxDataAmount - sysList.count))
    }

    func resetChart() {
        sysList.removeAll()
        netList.removeAll()
        startDate = Date()
        endDate = Date().addingTimeInterval(TimeInterval(maxDataAmount + spaceToEnd))
    }
}

enum ChartLineType: String, Plottable {
    case cpuTemp = "chartCpuTemp"
    case cpuUsage = "chartCpuUsage"
    case memUsage = "chartMemUsage"
    case netDwByte = "chartDlBytes"
    case netUlByte = "chartUlBytes"

    func toNSL() -> String {
        rawValue.toNSL()
    }
}

/// Chart pack
struct ChartData: Identifiable {
    let id = UUID()
    var charts: [SingleChart] = []
    var timestamp: Date
}

/// Single Chart
struct SingleChart: Identifiable {
    let id = UUID()
    var title: String
    var value: Double
    var type: ChartLineType
}
