//
//  ServerMonit0rApp.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import SwiftUI
import Network
import SwiftyJSON

@main
struct ServerMonit0rApp: App {
    @StateObject var serverData = ConnectionData()
    
    init(){
        // set auto connect
        if SavedUserDefaults.autoConn{
            SavedUserDefaults.manualConn = true
        }
        UIApplication.shared.isIdleTimerDisabled = !SavedUserDefaults.srcAlwaysOn
    }
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(serverData)
        }
    }
}

/**
 connection
 */
class ConnectionData: ObservableObject{
    // ui data
    @Published var cpuUsage: Double = 0
    @Published var cpuTemp: Double = 0
    @Published var cpuFreq: Double = 0
    @Published var memUsage: Double = 0
    @Published var uptime: String = "N/A"
    @Published var dlSpeed: String = "N/A"
    @Published var ulSpeed: String = "N/A"
    @Published var btnText: String = "connect".toNSL()
    
    // connection
    var isConnected = false
    var conn: NWConnection? = nil
    var ip = "127.0.0.1"
    var port: UInt16 = 9943
    var spdUnit = 0
    let timeout = 3
    
    // view
    @Published var alertTitle: String = ""
    @Published var alertMsg: String?
    @Published var alertIsPresented = false
    
    init(){
        // set auto connect
        if SavedUserDefaults.manualConn{
            setConnect()
        }
    }
    
    deinit{
        setDisconnect()
    }
    
    private func createConnection(){
        ip = SavedUserDefaults.ipAddr == "" ? ip : SavedUserDefaults.ipAddr
        port = SavedUserDefaults.port == "" ? port : UInt16(SavedUserDefaults.port) ?? port
        conn = NWConnection(host: NWEndpoint.Host(ip),
                            port: NWEndpoint.Port(integerLiteral: port),
                            using: .tcp)
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeout), repeats: false){[self] _ in
            alertTitle = "connectFailed".toNSL()
            alertMsg = "connectFailedHint".toNSL()
            alertIsPresented = true
            self.setDisconnect()
        }
        conn?.stateUpdateHandler = { newState in
            switch newState{
            case .preparing:
                DispatchQueue.main.async {
                    self.btnText = "connecting".toNSL()
                }
            case .ready:
                timer.invalidate()
                DispatchQueue.main.async {
                    self.btnText = "disconnect".toNSL()
                }
                self.receiveData()
            case .failed(let error):
                print("state failed \(error)")
            case .cancelled:
                DispatchQueue.main.async {
                    self.btnText = "connect".toNSL()
                }
            default:
                print("state: \(newState)")
            }
        }
        conn?.start(queue: .global())
    }
    
    /// receive data
    ///
    /// This will recursive until disconnect (Any concurrecy func?)
    private func receiveData(){
        conn?.receive(minimumIncompleteLength: 0, maximumLength: 1024){[self] content, _, isComplete, receError in
            if let _ = receError {
                setDisconnect()
            } else {
                if let content = content {
                    let json = JSON(content)
                    DispatchQueue.main.async {[self] in
                        cpuUsage = json["cpu"]["cpuUsage"].doubleValue / 100
                        let temp = json["cpu"]["cpuTemp"].doubleValue / 100
                        cpuTemp = temp == -1000 ? 0 : temp
                        cpuFreq = json["cpu"]["cpuFreq"].doubleValue / 5000
                        memUsage = json["mem"]["memUsage"].doubleValue / 100
                        uptime = json["other"]["upTime"].stringValue
                        let rawDlSpd = json["net"]["netDownload"].doubleValue.roundTo(2)
                        let rawUlSpd = json["net"]["netUpload"].doubleValue.roundTo(2)
                        dlSpeed = "\(rawDlSpd) Mbps"
                        ulSpeed = "\(rawUlSpd) Mbps"
                    }
                }
                
                // redo rcv
                if self.isConnected{
                    receiveData()
                }
            }
            
            if isComplete {
                setDisconnect()
            }
        }
    }
    
    /**
     btnConnect trigger
     */
    func onConnectClick(){
        isConnected = !isConnected
        if isConnected{
            setConnect()
        }else{
            setDisconnect()
        }
    }
    
    /**
     Connect
     */
    private func setConnect(){
        isConnected = true
        SavedUserDefaults.manualConn = true
        createConnection()
        btnText = "disconnect".toNSL()
    }
    
    /**
     Disconnect
     */
    private func setDisconnect(){
        isConnected = false
        SavedUserDefaults.manualConn = false
        if conn?.state == .ready || conn?.state == .preparing{
            conn?.forceCancel()
        }
        DispatchQueue.main.async {
            self.btnText = "connect".toNSL()
        }
        clearUi()
    }
    
    func resetConnect(autoConnect: Bool = false){
        setDisconnect()
    }
    
    private func clearUi(){
        DispatchQueue.main.async {[self] in
            cpuUsage = 0
            cpuTemp = 0
            cpuFreq = 0
            memUsage = 0
            uptime = "N/A"
            dlSpeed = "N/A"
            ulSpeed = "N/A"
        }
    }
}
