//
//  ViewUtilities.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/6/21.
//

import SwiftUI
extension Color {
    public static var accentVariantColor: Color {
        get{
            return Color("AccentVariantColor")
        }
    }
    
    public static var backgroundColor: Color {
        get{
            return Color("BackgroundColor")
        }
    }
    
    public static var textColor: Color {
        get{
            return Color("TextColor")
        }
    }
}


extension UINavigationBarAppearance {
    func setColor(title: UIColor? = nil, background: UIColor? = nil) {
        configureWithTransparentBackground()
//        configureWithOpaqueBackground()
//        configureWithDefaultBackground()
        if let titleColor = title {
            largeTitleTextAttributes = [.foregroundColor: titleColor]
            titleTextAttributes = [.foregroundColor: titleColor]
        }
        
        backgroundColor = background
        
//        UINavigationBar.appearance().scrollEdgeAppearance = self
        UINavigationBar.appearance().standardAppearance = self
    }
}
