//
//  ServerMonit0rApp.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import Network
import SwiftUI
import SwiftyJSON

@main
struct ServerMonit0rApp: App {
    @StateObject var serverData = ConnectionData()

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
                .environmentObject(serverData)
        }
    }
}

/**
 Socket connector
 */
class ConnectionData: ObservableObject {
    // ui data
    @Published var cpuUsage: Double = 0
    @Published var cpuUsageHint: String?
    @Published var cpuTemp: Double = 0
    @Published var cpuTempHint: String?
    @Published var cpuFreq: Double = 0
    @Published var cpuFreqHint: String?
    @Published var memUsage: Double = 0
    @Published var memUsageHint: String?
    @Published var uptime: String = "N/A"
    @Published var dlSpeed: String = "N/A"
    @Published var ulSpeed: String = "N/A"
    @Published var btnText: String = "connect".toNSL()

    // connection
    var isConnected = false
    var conn: NWConnection?
    var ip = "127.0.0.1"
    var port: UInt16 = 9943
    var spdUnit: SpdUnit = .mbps
    var timer: Timer?
    let timeout = 15

    // view
    @Published var alertTitle: String = ""
    @Published var alertMsg: String?
    @Published var alertIsPresented = false

    init() {
        // set auto connect
        if SavedUserDefaults.manualConn {
            connect()
        }
    }

    deinit {
        disconnect()
    }

    /**
     Socket Setup
     */

    /// Create connection with server
    ///
    /// Ip and Port will refresh if call this again.
    private func createConnection() {
        ip = SavedUserDefaults.ipAddr == "" ? ip : SavedUserDefaults.ipAddr
        port = SavedUserDefaults.port == "" ? port : UInt16(SavedUserDefaults.port) ?? port
        conn = NWConnection(host: NWEndpoint.Host(ip),
                            port: NWEndpoint.Port(integerLiteral: port),
                            using: .tcp)
        spdUnit = SpdUnit(rawValue: SavedUserDefaults.spdUnit) ?? .mbps

        // timeout timer
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeout), repeats: false) { [self] _ in
            alertTitle = "connectFailed".toNSL()
            alertMsg = "connectFailedHint".toNSL()
            alertIsPresented = true
            self.disconnect()
        }

        // connect state
        conn?.stateUpdateHandler = { newState in
            switch newState {
            case .preparing:
                DispatchQueue.main.async {
                    self.btnText = "connecting".toNSL()
                }
            case .ready:
                self.timer?.invalidate()
                DispatchQueue.main.async {
                    self.btnText = "disconnect".toNSL()
                }
                self.receiveData()
            case let .failed(error):
                print("state failed \(error)")
            case .cancelled:
                self.timer?.invalidate()
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
    /// This will recursive until disconnect or error
    private func receiveData() {
        conn?.receive(minimumIncompleteLength: 0, maximumLength: 1024) { [self] content, _, _, recvError in
            if let err = recvError {
                if err == .posix(.ENODATA) {
                    DispatchQueue.main.async { [weak self] in
                        self?.alertTitle = "connectServerDown".toNSL()
                        self?.alertMsg = "connectServerDownHint".toNSL()
                        self?.alertIsPresented = true
                    }
                }

                DispatchQueue.main.async { [weak self] in
                    self?.disconnect()
                }
            } else {
                if let content = content {
                    let json = JSON(content)
                    DispatchQueue.main.async { [weak self] in
                        // usage
                        let usage = json["cpu"]["cpuUsage"].doubleValue
                        self?.cpuUsage = usage / 100
                        self?.cpuUsageHint = "\(usage) %"

                        // temperature
                        let temp = json["cpu"]["cpuTemp"].doubleValue.roundTo(1)
                        self?.cpuTemp = temp == -1000 ? 0 : temp / 100
                        self?.cpuTempHint = temp == -1000 ? "n/a".toNSL() : "\(temp) ºC"

                        // freq
                        let freq = json["cpu"]["cpuFreq"].doubleValue.roundTo(2)
                        self?.cpuFreq = json["cpu"]["cpuFreq"].doubleValue / 5000
                        self?.cpuFreqHint = "\(freq) Mhz"

                        // memory
                        let mem = json["mem"]["memUsage"].doubleValue.roundTo(1)
                        self?.memUsage = mem / 100
                        self?.memUsageHint = "\(mem) %"

                        // other
                        self?.uptime = json["other"]["upTime"].stringValue

                        // network
                        let rawDlSpd = json["net"]["netDownload"].doubleValue.roundTo(2)
                        let rawUlSpd = json["net"]["netUpload"].doubleValue.roundTo(2)
                        if self?.spdUnit == .mbps {
                            self?.dlSpeed = "\(rawDlSpd) Mbps"
                            self?.ulSpeed = "\(rawUlSpd) Mbps"
                        } else {
                            self?.dlSpeed = "\((rawDlSpd / 8).roundTo(2)) MB/s"
                            self?.ulSpeed = "\((rawDlSpd / 8).roundTo(2)) MB/s"
                        }
                    }
                }

                // redo rcv
                if self.isConnected {
                    receiveData()
                }
            }
        }
    }

    /// btnConnect trigger
    func onConnectClick() {
        isConnected = !isConnected
        if isConnected {
            connect()
        } else {
            disconnect()
        }
    }

    /**
     Connection
     */

    /// Connect
    private func connect() {
        isConnected = true
        SavedUserDefaults.manualConn = true
        createConnection()
        btnText = "disconnect".toNSL()
    }

    /// Disconnect
    func disconnect() {
        timer?.invalidate()
        isConnected = false
        SavedUserDefaults.manualConn = false
        if conn?.state == .ready || conn?.state == .preparing {
            conn?.forceCancel()
        }
        btnText = "connect".toNSL()
        clearUi()
    }

    /// clear ui data
    private func clearUi() {
        cpuUsage = 0
        cpuUsageHint = nil
        cpuTemp = 0
        cpuTempHint = nil
        cpuFreq = 0
        cpuFreqHint = nil
        memUsage = 0
        memUsageHint = nil
        uptime = "N/A"
        dlSpeed = "N/A"
        ulSpeed = "N/A"
    }
}
