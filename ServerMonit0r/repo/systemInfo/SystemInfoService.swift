//
//  systemInfoService.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2023/3/7.
//

import Foundation

protocol SystemInfoService {
    func getSystemInfo(completion: @escaping (Result<SystemInfoEntity, Error>) -> Void) -> Task<Void, Never>?
}

class SystemInfoRemoteService: SystemInfoService {
    func getSystemInfo(completion: @escaping (Result<SystemInfoEntity, Error>) -> Void) -> Task<Void, Never>? {
        Task {
            let result = await ApiRequest.execute(.systemInfo,
                                                  method: .get,
                                                  params: nil,
                                                  resultType: SystemInfoEntity.self)

            completion(result)
        }
    }
}
