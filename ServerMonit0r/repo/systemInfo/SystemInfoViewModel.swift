//
//  SystemInfoData.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/13.
//

import Foundation

class SystemInfoViewModel: ObservableObject {
    @Published var cpuList = [SystemInfoDataCell]()
    @Published var osList = [SystemInfoDataCell]()
    @Published var memList = [SystemInfoDataCell]()
    @Published var diskList = [DiskViewItem]()
    @Published var errorAlert = false
    private(set) var errorMsg: String?
    var service: SystemInfoService?

    private var task: Task<Void, Never>? {
        willSet {
            task?.cancel()
        }
    }

    init(service: SystemInfoService?) {
        self.service = service
        task = getInfoData()
    }

    deinit {
        task?.cancel()
    }

    func getInfoData() -> Task<Void, Never>? {
        service?.getSystemInfo { [weak self] data in
            DispatchQueue.main.async {
                do {
                    self?.showResult(try data.get())
                } catch {
                    self?.errorAlert = true
                    self?.errorMsg = error.localizedDescription
                }
            }
        }
    }

    /// publish data
    private func showResult(_ data: SystemInfoEntity?) {
        guard let data else { return }
        let fetcher = SystemInfoFetcher()
        cpuList = fetcher.fetchCpuData(data)
        osList = fetcher.fetchOsData(data)
        memList = fetcher.fetchMemData(data)
        diskList = fetcher.fetchDiskData(data)
    }
}

struct SystemInfoDataCell: Identifiable {
    let id = UUID()
    let title: String
    let value: String?
}
