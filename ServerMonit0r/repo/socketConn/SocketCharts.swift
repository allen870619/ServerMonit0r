//
//  SocketCharts.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/15.
//

import Foundation
import iOSCommonUtils

class ChartViewModel: ObservableObject {
    @Published var list = [ChartData]()
    private let maxDataAmount = 230
    private(set) var startDate = Date() {
        didSet {
            endDate = startDate.addingTimeInterval(241)
        }
    }

    private(set) var endDate = Date()

    func appendData(data: ChartData) {
        var data = data
        data.time = Date(timeIntervalSince1970: data.timestamp)
        list.append(data)

        if list.count == 1 {
            startDate = Date(timeIntervalSince1970: data.timestamp)
        }

        if list.count > maxDataAmount {
            startDate = startDate.addingTimeInterval(1)
            list.removeFirst()
        }
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    var temp: Double
    var cpuUsage: Double
    var memUsage: Double
    var timestamp: Double
    var time: Date = .init()
}
