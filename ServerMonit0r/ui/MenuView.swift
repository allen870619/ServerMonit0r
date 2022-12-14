//
//  MenuView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/31.
//

import SwiftUI

struct MenuView: View {
    private let menuList = ["dashboard", "systemInfo", "settings"]
    @State private var selectedPage: String? = "dashboard"

    var body: some View {
        NavigationSplitView {
            List(menuList, id: \.self, selection: $selectedPage) { str in
                Text(str.toNSL()).padding(.vertical, 4)
            }
            .navigationTitle("menu".toNSL())
            .foregroundColor(.textColor)
        } detail: {
            if let selectedPage {
                if selectedPage == "dashboard" {
                    MainView()
                } else if selectedPage == "systemInfo" {
                    SystemInfoView()
                } else if selectedPage == "settings" {
                    SettingsView()
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
