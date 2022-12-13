//
//  SystemInfoData.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/13.
//

import Foundation
class SystemInfoData: ObservableObject {
    @Published var cpuList = [(String, String?)]()
    @Published var osList = [(String, String?)]()
    @Published var memList = [(String, String?)]()
    @Published var diskList = [DiskViewList]()

    private var task: Task<Void, Never>?
    init() {
        task?.cancel()
        task = Task {
            await getData()
        }
    }

    deinit {
        task?.cancel()
    }

    @Sendable func getData() async {
        let resp = try? await ApiRequest.getData(.systemInfo, method: .get, params: nil, resultType: SystemInfoEntity.self).data
        if let resp {
            result(resp)
        }
    }

    private func result(_ data: SystemInfoEntity) {
        DispatchQueue.main.async {
            self.cpuList = self.fetchCpuData(data)
            self.osList = self.fetchOsData(data)
            self.memList = self.fetchMemData(data)
            self.diskList = self.fetchDiskData(data)
        }
    }

    private func fetchOsData(_ data: SystemInfoEntity) -> [(String, String?)] {
        var list = [(String, String?)]()
        list.append(("pcName", data.os.pcName))
        list.append(("osType", data.os.osType))
        list.append(("osVerion", data.os.osVerion))
        list.append(("machine", data.os.machine))
        list.append(("osRelease", data.os.osRelease))
        return list
    }

    private func fetchCpuData(_ data: SystemInfoEntity) -> [(String, String?)] {
        var list = [(String, String?)]()
        list.append(("modelName", data.cpu.modelName))
        list.append(("vendor", data.cpu.vendor))
        list.append(("hardware", data.cpu.hardware))
        list.append(("physicalCore", data.cpu.physicalCore.formatted()))
        list.append(("logicalCore", data.cpu.logicalCore.formatted()))
        list.append(("l1Cache", data.cpu.l1Cache))
        list.append(("l2Cache", data.cpu.l2Cache))
        list.append(("l3Cache", data.cpu.l3Cache))
        return list
    }

    private func fetchMemData(_ data: SystemInfoEntity) -> [(String, String?)] {
        var list = [(String, String?)]()
        list.append(("ramVirtual", data.memory.ramVirtual))
        list.append(("ramSwap", data.memory.ramSwap))
        return list
    }

    private func fetchDiskData(_ data: SystemInfoEntity) -> [DiskViewList] {
        var list = [DiskViewList]()
        for disk in data.memory.disk {
            var diskData = [(String, String?)]()
            diskData.append(("device", disk.device))
            diskData.append(("mount", disk.mount))
            diskData.append(("fstype", disk.fstype))
            diskData.append(("diskUsed", disk.diskUsed))
            diskData.append(("diskFree", disk.diskFree))
            diskData.append(("diskPercent", ((disk.diskPercent ?? 0) / 100).formatted(.percent)))
            diskData.append(("diskTotal", disk.diskTotal))
            let diskInfo = DiskViewList(device: disk.device, dataList: diskData)
            list.append(diskInfo)
        }
        return list
    }
}

struct DiskViewList {
    var device: String
    var dataList: [(String, String?)]
}
