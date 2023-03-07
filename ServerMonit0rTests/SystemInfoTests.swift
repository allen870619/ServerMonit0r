//
//  SystemInfoTests.swift
//  ServerMonit0rTests
//
//  Created by Lee Yen Lin on 2023/3/7.
//

@testable import ServerMonit0r
import XCTest

final class SystemInfoTests: XCTestCase {
    var viewModel: SystemInfoViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSystemData() {
        viewModel = .init(service: MockSuccessService())
        let expect = XCTestExpectation()
        Task {
            await viewModel?.getInfoData()?.value
            DispatchQueue.main.async {
                expect.fulfill()
            }
        }
        wait(for: [expect], timeout: 1)
        XCTAssertEqual(viewModel?.cpuList.first?.value, "Apple M1")
    }

    func testOccurOnError() {
        viewModel = .init(service: MockErrorService())
        let expect = XCTestExpectation()
        Task {
            await viewModel?.getInfoData()?.value
            DispatchQueue.main.async {
                expect.fulfill()
            }
        }

        wait(for: [expect], timeout: 1)
        XCTAssertTrue((viewModel?.errorMsg?.contains("Test Error")) != nil)
    }
}

private class MockErrorService: SystemInfoService {
    func getSystemInfo(completion: @escaping (Result<ServerMonit0r.SystemInfoEntity, Error>) -> Void) -> Task<Void, Never>? {
        Task {
            completion(.failure(NSError(domain: "Test Error", code: 1)))
        }
    }
}

private class MockSuccessService: SystemInfoService {
    func getSystemInfo(completion: @escaping (Result<ServerMonit0r.SystemInfoEntity, Error>) -> Void) -> Task<Void, Never>? {
        let osMockData = OsEntity(machine: "MacBook Pro",
                                  osRawVersion: "macOS 11.5.1",
                                  osRelease: "20B50",
                                  osType: "Darwin",
                                  osVerion: "11.5.1",
                                  pcName: "JohnDoeMac",
                                  platform: "x86_64")
        let cpuMockData = CpuEntity(arch: "ARM64",
                                    hardware: "Apple M1",
                                    l1Cache: "128 KB",
                                    l2Cache: "12 MB",
                                    l3Cache: nil,
                                    logicalCore: 8,
                                    modelName: "Apple M1",
                                    physicalCore: 4,
                                    vendor: "Apple Inc.")
        // swiftlint:disable all
        let diskMockData1 = DiskEntity(device: "/dev/disk1s1", mount: "/", fstype: "apfs", diskTotal: "121.3 GB", diskUsed: "86.5 GB", diskFree: "34.8 GB", diskPercent: 71.3)
        let diskMockData2 = DiskEntity(device: "/dev/disk1s5", mount: "/private/var/vm", fstype: "apfs", diskTotal: "121.3 GB", diskUsed: nil, diskFree: nil, diskPercent: nil)
        let memoryMockData = MemoryEntity(ramVirtual: "16 GB",
                                          ramSwap: "2 GB",
                                          disk: [diskMockData1, diskMockData2])
        return Task {
            completion(.success(.init(os: osMockData, cpu: cpuMockData, memory: memoryMockData)))
        }
    }
}
