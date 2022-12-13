//
//  Extension.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/12.
//

import Foundation

@propertyWrapper
struct NilOnTypeMismatch<Value> {
    var wrappedValue: Value?
}

extension NilOnTypeMismatch: Decodable where Value: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try? container.decode(Value.self)
    }
}
