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
    init(){
        if SavedUserDefaults.autoConn{
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

class ServerData: ObservableObject{
    @Published var cpuUsage: Double = 0
    @Published var cpuTemp: Double = 0
    @Published var cpuFreq: Double = 0
    @Published var memUsage: Double = 0
    @Published var upTime: String = "N/A"
    @Published var btnText: String = "Connect"
    var isConnect = false
    var task: Task<(), Error>? = nil
    var conn: NWConnection? = nil
    var ip = "127.0.0.1"
    var port: UInt16 = 9943
    
    init(){
        ip = SavedUserDefaults.ipAddr == "" ? ip : SavedUserDefaults.ipAddr
        port = SavedUserDefaults.port == "" ? port : UInt16(SavedUserDefaults.port) ?? port
        if SavedUserDefaults.manualConn{
            setConnect()
        }
    }
    
    deinit{
        setDisconnect()
    }
    
    private func createConnection(){
        conn = NWConnection(host: NWEndpoint.Host(ip),
                            port: NWEndpoint.Port(integerLiteral: port),
                            using: .tcp)
        
        conn?.stateUpdateHandler = { newState in
            switch newState{
            case .setup:
                print("state setup")
            case .waiting(let error):
                print("state waiting \(error)")
            case .preparing:
                print("state preparing")
                DispatchQueue.main.async {
                    self.btnText = "Connecting..."
                }
            case .ready:
                print("state ready")
                DispatchQueue.main.async {
                    self.btnText = "Disconnect"
                }
                self.receiveData()
            case .failed(let error):
                print("state failed \(error)")
            case .cancelled:
                print("state cancel")
            @unknown default:
                print(newState)
            }
        }
        conn?.start(queue: .global())
    }
    
    private func receiveData(){
        conn?.receive(minimumIncompleteLength: 0, maximumLength: 1024){[self] content, context, isComplete, receError in
            if let _ = receError {
                conn?.cancel()
            } else {
                if let content = content {
                    let json = JSON(content)
                    DispatchQueue.main.async {[self] in
                        cpuUsage = json["cpu"]["cpuUsage"].doubleValue / 100
                        let temp = json["cpu"]["cpuTemp"].doubleValue / 100
                        cpuTemp = temp == -1000 ? 0 : temp
                        cpuFreq = json["cpu"]["cpuFreq"].doubleValue / 5000
                        memUsage = json["mem"]["memUsage"].doubleValue / 100
                        upTime = json["other"]["upTime"].stringValue
                    }
                    if self.isConnect{
                        receiveData()
                    }
                }
            }
            
            if isComplete {
                conn?.cancel()
            }
        }
    }
    
    /**
     btnConnect trigger
     */
    func onConnectClick(){
        isConnect = !isConnect
        if isConnect{
            setConnect()
        }else{
            setDisconnect()
        }
    }
    
    /**
      Connect
     */
    private func setConnect(){
        isConnect = true
        SavedUserDefaults.manualConn = true
        createConnection()
        btnText = "Disconnect"
    }
    
    /**
      Disconnect
     */
    private func setDisconnect(){
        isConnect = false
        SavedUserDefaults.manualConn = false
        conn?.forceCancel()
        btnText = "Connect"
        clearUi()
    }
    
    private func clearUi(){
        cpuUsage = 0
        cpuTemp = 0
        cpuFreq = 0
        memUsage = 0
        upTime = "N/A"
    }
    
    // mock
    private func updateUsage(){
        task = Task(){
            while true{
                if task?.isCancelled == true{
                    break
                }
                do{
                    DispatchQueue.main.async {
                        self.cpuUsage = Double.random(in: 0...1)
                        self.cpuTemp = Double.random(in: 0...1)
                        self.cpuFreq = Double.random(in: 0...1)
                        self.memUsage = Double.random(in: 0...1)
                    }
                    try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
                }
            }
        }
    }
}



