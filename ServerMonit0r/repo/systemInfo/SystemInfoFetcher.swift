//
//  SystemInfoFetcher.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/14.
//

import Foundation

class SystemInfoFetcher {
    /// fetch os info
    func fetchOsData(_ data: SystemInfoEntity) -> [SystemInfoDataCell] {
        var list = [SystemInfoDataCell]()
        list.append(.init(title: "pcName", value: data.os.pcName))
        list.append(.init(title: "osType", value: data.os.osType))
        list.append(.init(title: "osVerion", value: data.os.osVerion))
        list.append(.init(title: "machine", value: data.os.machine))
        list.append(.init(title: "osRelease", value: data.os.osRelease))
        return list
    }

    /// fetch cpu info
    func fetchCpuData(_ data: SystemInfoEntity) -> [SystemInfoDataCell] {
        var list = [SystemInfoDataCell]()
        list.append(.init(title: "modelName", value: data.cpu.modelName))
        list.append(.init(title: "vendor", value: data.cpu.vendor))
        list.append(.init(title: "physicalCore", value: data.cpu.physicalCore.formatted()))
        list.append(.init(title: "logicalCore", value: data.cpu.logicalCore.formatted()))
        list.append(.init(title: "l1Cache", value: data.cpu.l1Cache))
        list.append(.init(title: "l2Cache", value: data.cpu.l2Cache))
        list.append(.init(title: "l3Cache", value: data.cpu.l3Cache))
        return list
    }

    /// fetch memory info
    func fetchMemData(_ data: SystemInfoEntity) -> [SystemInfoDataCell] {
        var list = [SystemInfoDataCell]()
        list.append(.init(title: "ramVirtual", value: data.memory.ramVirtual))
        list.append(.init(title: "ramSwap", value: data.memory.ramSwap))
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
