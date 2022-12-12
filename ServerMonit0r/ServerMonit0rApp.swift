//
//  ServerMonit0rApp.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import SwiftUI

@main
struct ServerMonit0rApp: App {
    init() {
        // set auto connect
        if SavedUserDefaults.autoConn {
            SavedUserDefaults.manualConn = true
        }
        UIApplication.shared.isIdleTimerDisabled = !SavedUserDefaults.srcAlwaysOn
    }

    var body: some Scene {
        WindowGroup {
            MenuView()
        }
    }
}
