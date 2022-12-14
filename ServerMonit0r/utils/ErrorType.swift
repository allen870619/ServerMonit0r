//
//  ErrorType.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/13.
//

import Foundation

extension Error {
    static var jsonParseFailed: NSError {
        NSError(domain: "Json parse failed", code: 1)
    }

    static var urlError: NSError {
        NSError(domain: "Url format is wrong", code: 2)
    }

    static var emptyResponse: NSError {
        NSError(domain: "No response data", code: 3)
    }
}
