//
//  MenuView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/31.
//

import SwiftUI

struct MenuView: View {
    private let menuList = ["dashboard", "charts", "systemInfo", "settings", "about"]
    @State private var selectedPage: String? = "dashboard"

    var body: some View {
        NavigationSplitView {
            List(menuList, id: \.self, selection: $selectedPage) { str in
                Text(str.toNSL())
                    .font(.numFontWithChinese(size: 18))
                    .padding(.vertical, 4)
            }
            .navigationTitle("menu".toNSL())
            .foregroundColor(.textColor)
        } detail: {
            if let selectedPage {
                switch selectedPage {
                case "dashboard":
                    MainView()
                case "charts":
                    ChartsView()
                case "systemInfo":
                    SystemInfoView()
                case "settings":
                    SettingsView()
                case "about":
                    InfoView()
                default:
                    MainView()
                }
            } else {
                MainView()
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
