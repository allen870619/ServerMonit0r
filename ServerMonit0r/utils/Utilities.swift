//
//  Utilities.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/6/15.
//

import Foundation

extension String {
    func toNSL() -> String {
        NSLocalizedString(self, comment: self)
    }

    var emptyToNil: String? {
        if self == "" {
            return nil
        } else {
            return self
        }
    }
}

extension Double {
    func roundTo(_ digits: Int) -> Double {
        let decimal = Double(truncating: pow(10, digits) as NSNumber)
        return (self * decimal).rounded() / decimal
    }

    func parseMegaBytes() -> Double {
        let factor = 1024.0
        return self / factor / factor
    }
}
