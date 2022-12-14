//
//  SettingData.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/6/15.
//

import UIKit

class SettingsData: ObservableObject {
    @Published var ipValue = "127.0.0.1"
    @Published var portValue = "9943"
    @Published var scrAlwaysOn: Bool = false
    @Published var autoConnect: Bool = true
    @Published var selUnit: String = "spdUnitMbps".toNSL()
    let unit = ["spdUnitMbps".toNSL(), "spdUnitMBs".toNSL()]

    // alert
    @Published var alertTitle = "saved".toNSL()
    @Published var errMessage: String?
    @Published var showAlert = false

    init() {
        ipValue = SavedUserDefaults.ipAddr
        portValue = SavedUserDefaults.port
        scrAlwaysOn = SavedUserDefaults.srcAlwaysOn
        autoConnect = SavedUserDefaults.autoConn
        selUnit = unit[SavedUserDefaults.spdUnit]
    }

    /// Save setting
    func onSave() {
        let checkResult = checkInput()
        if checkResult == .noError {
            // save to userDefaults
            SavedUserDefaults.ipAddr = ipValue
            SavedUserDefaults.port = portValue
            SavedUserDefaults.srcAlwaysOn = scrAlwaysOn
            SavedUserDefaults.autoConn = autoConnect
            let index = unit.firstIndex(of: selUnit) ?? -1
            SavedUserDefaults.spdUnit = index <= 0 ? 0 : index

            // prevent screen sleep
            UIApplication.shared.isIdleTimerDisabled = !scrAlwaysOn

            // alert hint
            alertTitle = "saved".toNSL()
            errMessage = nil
            showAlert = true
        } else {
            alertTitle = "failed".toNSL()
            switch checkResult {
            case .noError:
                break
            case .ipFormat:
                errMessage = "ipWrongFormat".toNSL()
            case .portFormat:
                errMessage = "portWrongFormat".toNSL()
            }
            showAlert = true
        }
    }

    /// Check input format
    func checkInput() -> ErrorType {
        // check ip
        if ipValue != "" {
            let ipSeg = ipValue.split(separator: ".")
            if ipSeg.count != 4 {
                return .ipFormat
            }
            if ipSeg.contains(where: { UInt8($0) == nil }) {
                return .ipFormat
            }
        }

        // check port
        if UInt16(portValue) == nil {
            return .portFormat
        }

        return .noError
    }

    enum ErrorType: Int {
        case noError = 0
        case ipFormat = 1
        case portFormat = 2
    }
}

enum SpdUnit: Int {
    case mbps = 0
    case MBs = 1

    func getName() -> String {
        switch self {
        case .MBs:
            return "MB/s"
        case .mbps:
            return "Mbps"
        }
    }
}
