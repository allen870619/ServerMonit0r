//
//  ViewUtilities.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/6/21.
//

import SwiftUI

public extension Color {
    /// accent color
    static var accentVariantColor: Color {
        Color("AccentVariantColor")
    }

    /// default background color
    static var backgroundColor: Color {
        Color("BackgroundColor")
    }

    /// text color
    static var textColor: Color {
        Color("TextColor")
    }

    /// gauge gradient color - start
    static var gradientStart: Color {
        Color(red: 142 / 255, green: 202 / 255, blue: 230 / 255)
    }

    /// gauge gradient color - middle
    static var gradientMiddle: Color {
        Color(red: 142 / 255, green: 202 / 255, blue: 230 / 255)
    }

    /// gauge gradient color - end
    static var gradientEnd: Color {
        Color(red: 142 / 255, green: 202 / 255, blue: 230 / 255)
    }
}
