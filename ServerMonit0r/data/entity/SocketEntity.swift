//
//  SocketEntity.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/12.
//

import Foundation

struct SystemInfo: Decodable {
    var cpu: Cpu
    var mem: Memory
    var net: Network
    var other: Other
}

struct Cpu: Decodable {
    var cpuUsage: Double
    @NilOnTypeMismatch<Double>
    var cpuTemp: Double?
    var cpuFreq: Double
}

struct Memory: Decodable {
    var memUsage: Double
}

struct Network: Decodable {
    var netDownload: Double
    var netUpload: Double
}

struct Other: Decodable {
    var upTime: String
}
