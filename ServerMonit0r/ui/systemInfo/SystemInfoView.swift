//
//  SystemInfoView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/13.
//

import SwiftUI

struct SystemInfoView: View {
    @StateObject var viewModel = SystemInfoViewModel(service: SystemInfoRemoteService())

    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 160)), count: 2)

    var body: some View {
        Form {
            let list: [(name: String, list: [SystemInfoDataCell])] = [("os", viewModel.osList),
                                                                      ("cpu", viewModel.cpuList),
                                                                      ("memory", viewModel.memList)]
            ForEach(list, id: \.self.name) { type in
                Section(content: {
                    ForEach(type.list) { item in
                        SingleSystemInfoView(title: item.title, value: item.value)
                    }
                }, header: {
                    Text(type.name)
                        .font(.title3)
                })
                .listRowBackground(Color.white.opacity(0.25))
            }

            // disk
            Section {
                List(viewModel.diskList, children: \.list) { item in
                    SingleSystemInfoView(title: item.data.0, value: item.data.1)
                        .listRowBackground(Color.red)
                }
            } header: {
                Text("disk")
                    .font(.title3)
            }
            .listRowBackground(Color.white.opacity(0.25))
        }
        .refreshable {
            await viewModel.getInfoData()?.value
        }
        .scrollContentBackground(.hidden)
        .background(Color.backgroundColor)
        .navigationTitle("systemInfo".toNSL())
        .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)
        .alert("failed".toNSL(), isPresented: $viewModel.errorAlert, actions: {
            Button("ok".toNSL()) {}
        }, message: {
            Text(viewModel.errorMsg ?? "unknownError".toNSL())
        })
    }
}

struct SingleSystemInfoView: View {
    var title: String
    var value: String?

    var body: some View {
        VStack {
            HStack {
                Text(title.toNSL())
                    .font(.numFontWithChinese(size: 18))
                Spacer()
            }
            Text(value ?? "n/a".toNSL())
                .font(.numFontWithChinese(size: 18))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }
}

struct SystemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SystemInfoView(viewModel: SystemInfoViewModel(service: MockService()))
    }
}

class MockService: SystemInfoService {
    func getSystemInfo(completion: @escaping (Result<SystemInfoEntity, Error>) -> Void) -> Task<Void, Never>? {
        let osEntity = OsEntity(machine: "Machine",
                                osRawVersion: "osRawVersion",
                                osRelease: "osRelease",
                                osType: "osType",
                                osVerion: "osVersion",
                                pcName: "pcName",
                                platform: "platform")
        let cpuEntity = CpuEntity(arch: "arch",
                                  hardware: "hardware",
                                  l1Cache: "L1",
                                  l2Cache: "L2",
                                  l3Cache: "L3",
                                  logicalCore: 1,
                                  modelName: "modelName",
                                  physicalCore: 2,
                                  vendor: "vendor")
        let memoryEntity = MemoryEntity(ramVirtual: "ramVirtual",
                                        ramSwap: "rawSwap",
                                        disk: [.init(device: "device", mount: "mount", fstype: "fstype", diskTotal: "diskTotal", diskUsed: "diskUsed", diskFree: "diskFree", diskPercent: 99.5)])
        let mockData = SystemInfoEntity(os: osEntity, cpu: cpuEntity, memory: memoryEntity)

        return Task {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                completion(.success(mockData))
            } catch {
                completion(.failure(NSError(domain: "Test", code: 123)))
            }
        }
    }
}
