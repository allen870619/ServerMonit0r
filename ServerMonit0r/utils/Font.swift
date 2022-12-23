//
//  Font.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/23.
//

import SwiftUI
import UIKit

class FontCustomize {
    static func fontFallbackCreator(primary: String, cascade: [String], size: CGFloat) -> UIFont? {
        guard let primaryFontDescriptor = UIFont(name: primary, size: size)?.fontDescriptor else {
            return nil
        }

        // cascade list
        var fallbackDescriptorList = [UIFontDescriptor]()
        for family in cascade {
            if let font = UIFont(name: family, size: size) {
                fallbackDescriptorList.append(font.fontDescriptor)
            }
        }

        // combine and return
        let fallbackDescriptor = primaryFontDescriptor.addingAttributes([.cascadeList: fallbackDescriptorList])
        return UIFont(descriptor: fallbackDescriptor, size: size)
    }
}

extension Font {
    static func numFontWithChinese(size: CGFloat) -> Font {
        let uiFont = FontCustomize.fontFallbackCreator(primary: "ZenDots-Regular",
                                                       cascade: ["Makinas-4-Flat",
                                                                 "NotoSansTC-Regular"],
                                                       size: size)
        return Font(uiFont!)
    }

    static func customChinese(size: CGFloat) -> Font {
        let uiFont = FontCustomize.fontFallbackCreator(primary: "Makinas-4-Flat",
                                                       cascade: ["NotoSansTC-Regular"],
                                                       size: size)
        return Font(uiFont!)
    }
}
