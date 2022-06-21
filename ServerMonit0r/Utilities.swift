//
//  Utilities.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/6/15.
//

import Foundation
import SwiftUI
extension String{
    func toNSL() -> String{
        return NSLocalizedString(self, comment: self)
    }
}

extension Double{
    func roundTo(_ digits: Int) -> Double{
        let decimal = Double(truncating: pow(10, digits) as NSNumber)
        return (self * decimal).rounded() / decimal
    }
}
