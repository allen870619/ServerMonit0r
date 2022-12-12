//
//  SavedUserDefaults.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/6/15.
//

import Foundation

class SavedUserDefaults {
    /**
     IP address
     */
    static var ipAddr: String {
        get {
            UserDefaults().string(forKey: "ipAddr") ?? ""
        }
        set {
            UserDefaults().set(newValue, forKey: "ipAddr")
        }
    }

    /**
     Port number
     */
    static var port: String {
        get {
            UserDefaults().string(forKey: "port") ?? ""
        }
        set {
            UserDefaults().set(newValue, forKey: "port")
        }
    }

    /**
     Screen always on.
     */
    static var srcAlwaysOn: Bool {
        get {
            UserDefaults().bool(forKey: "srcAlwaysOn")
        }
        set {
            UserDefaults().set(newValue, forKey: "srcAlwaysOn")
        }
    }

    /**
     Auto connect when enter dashboard
     */
    static var autoConn: Bool {
        get {
            UserDefaults().bool(forKey: "autoConn")
        }
        set {
            UserDefaults().set(newValue, forKey: "autoConn")
        }
    }

    /**
     Network speed unit

     0: MB/s
     1: Mbps
     */
    static var spdUnit: Int {
        get {
            UserDefaults().integer(forKey: "spdUnit")
        }
        set {
            UserDefaults().set(newValue, forKey: "spdUnit")
        }
    }

    /**
     Manual connect by user
     */
    static var manualConn: Bool {
        get {
            UserDefaults().bool(forKey: "manualConn")
        }
        set {
            UserDefaults().set(newValue, forKey: "manualConn")
        }
    }

    static func test() {
        print(ipAddr)
        print(port)
        print(srcAlwaysOn)
        print(autoConn)
        print(spdUnit)
    }
}
