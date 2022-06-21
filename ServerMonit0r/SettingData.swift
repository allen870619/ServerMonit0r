//
//  SettingData.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/6/15.
//

import Foundation
import UIKit

class SettingsData: ObservableObject{
    @Published var ipValue = ""
    @Published var portValue = ""
    @Published var scrAlwaysOn: Bool = false
    @Published var autoConnect: Bool = true
    @Published var selUnit: String = "spdUnitMbps".toNSL()
    let unit = ["spdUnitMbps".toNSL(), "spdUnitMBs".toNSL()]
    
    // alert
    @Published var alertTitle = "saved".toNSL()
    @Published var errMessage: String?
    @Published var showAlert = false
    
    init(){
        ipValue = SavedUserDefaults.ipAddr
        portValue = SavedUserDefaults.port
        scrAlwaysOn = SavedUserDefaults.srcAlwaysOn
        autoConnect = SavedUserDefaults.autoConn
        selUnit = unit[SavedUserDefaults.spdUnit]
    }
    
    func onSave(){
        let checkResult = checkInput()
        if checkResult == .noError{
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
        }else{
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
    
    /**
     Check input format
     */
    func checkInput() -> ErrorType {
        // check ip
        if ipValue != ""{
            let ip = ipValue.split(separator: ".")
            if ip.count != 4{
                return .ipFormat
            }
            for i in ip{
                if UInt8(i) == nil{
                    return .ipFormat
                }
            }
        }
        
        // check port
        if portValue != ""{
            if UInt16(portValue) == nil{
                return .portFormat
            }
        }
        
        return .noError
    }
    
    enum ErrorType: Int{
        case noError = 0
        case ipFormat = 1
        case portFormat = 2
    }
}

enum SpdUnit: Int{
    case mbps = 0
    case MBs = 1
}

