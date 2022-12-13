//
//  SystemInfoEntity.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/13.
//

import Foundation

struct SystemInfoEntity: Decodable {
    let os: OsEntity
    let cpu: CpuEntity
    let memory: MemoryEntity
}

struct OsEntity: Decodable {
    let machine: String
    let osRawVersion: String
    let osRelease: String
    let osType: String
    let osVerion: String?
    let pcName: String
    let platform: String
}

struct CpuEntity: Decodable {
    let arch: String
    let hardware: String?
    let l1Cache: String?
    let l2Cache: String?
    let l3Cache: String?
    let logicalCore: Int
    let modelName: String
    let physicalCore: Int
    let vendor: String?
}

struct MemoryEntity: Decodable {
    let ramVirtual: String
    let ramSwap: String
    let disk: [DiskEntity]
}

struct DiskEntity: Decodable {
    let device: String
    let mount: String
    let fstype: String
    let diskTotal: String?
    let diskUsed: String?
    let diskFree: String?
    let diskPercent: Double?
}
