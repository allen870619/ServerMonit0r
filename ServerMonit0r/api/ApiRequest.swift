//
//  ApiRequest.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/12.
//

import Alamofire
import Foundation
import SwiftyJSON

class ApiRequest {
    static let shared = ApiRequest()

    private init() {}
    /// get data async
    static func getData<T: Decodable>(_ link: ConnectApi,
                                      suffix _: String? = nil,
                                      method: HTTPMethod = .post,
                                      params: [String: Any]?,
                                      resultType: T.Type = JSON.self) async throws -> (data: T?, json: JSON) {
        guard let url = URL(string: "\(NetworkConfig.targetBaseUrl)\(link.rawValue)") else {
            throw NSError.urlError
        }

        let req = AF.request(url,
                             method: method,
                             parameters: params,
                             encoding: URLEncoding(),
                             headers: .default,
                             requestModifier: { $0.timeoutInterval = NetworkTiming.timeoutRequest })
        let rawJson = try await req.serializingDecodable(JSON.self, automaticallyCancelling: true).value
        var result: T?
        if resultType != JSON.self {
            result = try JSONDecoder().decode(resultType.self, from: rawJson.rawData())
        }
        return (result, rawJson)
    }

    static func execute<T: Decodable>(
        _ link: ConnectApi,
        suffix _: String? = nil,
        method: HTTPMethod = .post,
        params: [String: Any]?,
        resultType _: T.Type = JSON.self
    ) async -> Result<T, Error> {
        guard let url = URL(string: "\(NetworkConfig.targetBaseUrl)\(link.rawValue)") else {
            return .failure(NSError.urlError)
        }

        let req = AF.request(url,
                             method: method,
                             parameters: params,
                             encoding: URLEncoding(),
                             headers: .default,
                             requestModifier: { $0.timeoutInterval = NetworkTiming.timeoutRequest })
        let json = try? await req.serializingDecodable(JSON.self, automaticallyCancelling: true).value

        if let json {
            let data = try? JSONDecoder().decode(T.self, from: json.rawData())
            if let data {
                return .success(data)
            } else {
                // TODO: add new error type
                return .failure(NSError.jsonParseFailed)
            }

        } else {
            return .failure(NSError.jsonParseFailed)
        }
    }
}
