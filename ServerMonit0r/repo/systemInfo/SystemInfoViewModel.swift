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
    var errorMsg: String?

    private var task: Task<Void, Never>? {
        willSet {
            task?.cancel()
        }
    }

    init() {
        task = Task {
            do {
                try await getData()
            } catch {
                DispatchQueue.main.async {
                    self.errorMsg = error.localizedDescription
                    self.errorAlert = true
                }
            }
        }
    }

    deinit {
        task?.cancel()
    }

    @Sendable func getData() async throws {
        let resp = try await ApiRequest.getData(.systemInfo,
                                                method: .get,
                                                params: nil,
                                                resultType: SystemInfoEntity.self).data
        showResult(resp)
    }

    /// set ui Data
    private func showResult(_ data: SystemInfoEntity?) {
        DispatchQueue.main.async { [weak self] in
            guard let self, let data else { return }
            let fetcher = SystemInfoFetcher()
            self.cpuList = fetcher.fetchCpuData(data)
            self.osList = fetcher.fetchOsData(data)
            self.memList = fetcher.fetchMemData(data)
            self.diskList = fetcher.fetchDiskData(data)
        }
    }
}

struct SystemInfoDataCell: Identifiable {
    let id = UUID()
    let title: String
    let value: String?
}
