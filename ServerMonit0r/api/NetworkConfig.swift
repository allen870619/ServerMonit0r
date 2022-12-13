//
//  NetworkConfig.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/12.
//

import Foundation

struct NetworkTiming {
    static let timeoutRequest: TimeInterval = 15
    static let timeoutResource: TimeInterval = 120

    static let picTimeoutRequest: TimeInterval = 30
    static let picTimeoutResource: TimeInterval = 120
    static let picRetry = 6
    static let retry = 2
}

enum NetworkConfig {
    private static let FORMAL_URL = "http://thxhf.work:8888"
    private static let TEST_URL = "http://localhost:8888"

    private static let BASE_URL = "/"

    // get desire Link
    static var targetBaseUrl: String {
        TEST_URL + BASE_URL
    }
}
