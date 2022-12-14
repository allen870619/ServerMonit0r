//
//  SystemInfoFetcher.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/14.
//

import Foundation

class SystemInfoFetcher {
    typealias DataUnit = [(title: String, value: String?)]
    /// fetch os info
    func fetchOsData(_ data: SystemInfoEntity) -> DataUnit {
        var list = [(String, String?)]()
        list.append(("pcName", data.os.pcName))
        list.append(("osType", data.os.osType))
        list.append(("osVerion", data.os.osVerion))
        list.append(("machine", data.os.machine))
        list.append(("osRelease", data.os.osRelease))
        return list
    }

    /// fetch cpu info
    func fetchCpuData(_ data: SystemInfoEntity) -> DataUnit {
        var list = [(String, String?)]()
        list.append(("modelName", data.cpu.modelName))
        list.append(("vendor", data.cpu.vendor))
        //        list.append(("hardware", data.cpu.hardware))
        list.append(("physicalCore", data.cpu.physicalCore.formatted()))
        list.append(("logicalCore", data.cpu.logicalCore.formatted()))
        list.append(("l1Cache", data.cpu.l1Cache))
        list.append(("l2Cache", data.cpu.l2Cache))
        list.append(("l3Cache", data.cpu.l3Cache))
        return list
    }

    /// fetch memory info
    func fetchMemData(_ data: SystemInfoEntity) -> DataUnit {
        var list = [(String, String?)]()
        list.append(("ramVirtual", data.memory.ramVirtual))
        list.append(("ramSwap", data.memory.ramSwap))
        return list
    }

    /// fetch disk info
    func fetchDiskData(_ data: SystemInfoEntity) -> [DiskViewItem] {
        var list = [DiskViewItem]()
        for disk in data.memory.disk {
            var tmplist = [DiskViewItem]()
            tmplist.append(.init(data: ("mount", disk.mount)))
            tmplist.append(.init(data: ("fstype", disk.fstype)))
            tmplist.append(.init(data: ("diskUsed", disk.diskUsed)))
            tmplist.append(.init(data: ("diskFree", disk.diskFree)))
            tmplist.append(.init(data: ("diskPercent", ((disk.diskPercent ?? 0) / 100).formatted(.percent))))
            tmplist.append(.init(data: ("diskTotal", disk.diskTotal)))
            list.append(.init(data: ("device", disk.device), list: tmplist))
        }
        return list.sorted()
    }
}

struct DiskViewItem: Identifiable, Comparable {
    static func < (lhs: DiskViewItem, rhs: DiskViewItem) -> Bool {
        lhs.data.value ?? "" < rhs.data.value ?? ""
    }

    static func == (lhs: DiskViewItem, rhs: DiskViewItem) -> Bool {
        lhs.data.key == rhs.data.key
    }

    let id = UUID()
    var data: (key: String, value: String?)
    var list: [DiskViewItem]?
}
