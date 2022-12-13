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

    /// gauge gradient color - normal start
    static var gradientNormalStart: Color {
        Color(red: 0.56, green: 0.79, blue: 0.9)
    }

    /// gauge gradient color - normal end
    static var gradientNormalEnd: Color {
        Color(red: 0.96, green: 0.73, blue: 0.25)
    }

    /// gauge gradient color - fair start
    static var gradientFairStart: Color {
        Color(red: 0.41, green: 0.69, blue: 0.83)
    }

    /// gauge gradient color - fair end
    static var gradientFairEnd: Color {
        Color(red: 0.89, green: 0.50, blue: 0.28)
    }

    /// gauge gradient color - severe start
    static var gradientSevereStart: Color {
        Color(red: 0.25, green: 0.58, blue: 0.76)
    }

    /// gauge gradient color - severe end
    static var gradientSevereEnd: Color {
        Color(red: 0.83, green: 0.28, blue: 0.30)
    }
}

/// ref https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
