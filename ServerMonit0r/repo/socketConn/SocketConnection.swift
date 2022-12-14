//
//  SocketConnection.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/9.
//

import Foundation
import Network
import SwiftyJSON

class SocketConnection: ObservableObject {
    // ui data
    @Published var cpuUsage: Double = 0
    @Published var cpuTemp: Double = 0
    @Published var cpuFreq: Double = 0
    @Published var memUsage: Double = 0
    @Published var dlSpeed: Double = 0
    @Published var ulSpeed: Double = 0
    @Published var uptime: String = "n/a".toNSL()
    @Published var spdUnitText: String = "Mbps"
    @Published var connStatus: ConnStatus = .disconnect {
        didSet {
            switch connStatus {
            case .disconnect:
                btnConnTitle = "connect".toNSL()
            case .connecting:
                btnConnTitle = "connecting".toNSL()
            case .connected:
                btnConnTitle = "disconnect".toNSL()
            }
        }
    }

    @Published var btnConnTitle = "connect".toNSL()
    // alert
    @Published var alertTitle: String = ""
    @Published var alertMsg: String?
    @Published var alertIsPresented = false

    @Published var list = [ChartData]()
    var count = 0
    var chartDelta = 0

    // connection
    var ip = "127.0.0.1"
    var port: UInt16 = 9943
    var spdUnit: SpdUnit = .mbps {
        didSet {
            spdUnitText = spdUnit.getName()
        }
    }

    private var conn: NWConnection?
    private var timer: Timer?
    private let timeout = 15

    // singleton
    static let shared = SocketConnection()

    private init() {
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
        ip = SavedUserDefaults.ipAddr.isEmpty ? ip : SavedUserDefaults.ipAddr
        port = SavedUserDefaults.port.isEmpty ? port : UInt16(SavedUserDefaults.port) ?? port
        conn = NWConnection(host: NWEndpoint.Host(ip),
                            port: NWEndpoint.Port(integerLiteral: port),
                            using: .tcp)
        spdUnit = SpdUnit(rawValue: SavedUserDefaults.spdUnit) ?? .mbps

        // timeout timer
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeout), repeats: false) { [weak self] _ in
            self?.alertTitle = "connectFailed".toNSL()
            self?.alertMsg = "connectFailedHint".toNSL()
            self?.alertIsPresented = true
            self?.disconnect()
        }

        // connect state
        conn?.stateUpdateHandler = { [weak self] newState in
            guard let self else { return }

            switch newState {
            case .preparing:
                DispatchQueue.main.async {
                    self.connStatus = .connecting
                }
            case .ready:
                self.timer?.invalidate()
                DispatchQueue.main.async {
                    self.connStatus = .connected
                    self.receiveData()
                }
            case let .failed(error):
                DispatchQueue.main.async {
                    self.connStatus = .disconnect
                    self.alertTitle = "connectFailed".toNSL()
                    self.alertMsg = "connectFailedHint".toNSL() + "\n\(error)"
                    self.alertIsPresented = true
                    self.disconnect()
                }
            case .cancelled:
                self.timer?.invalidate()
                DispatchQueue.main.async {
                    self.connStatus = .disconnect
                }
            default:
                self.timer?.invalidate()
                DispatchQueue.main.async {
                    self.connStatus = .disconnect
                    self.alertTitle = "connectFailed".toNSL()
                    self.alertMsg = "connectFailedHint".toNSL() + "\n\(newState)"
                    self.alertIsPresented = true
                    self.disconnect()
                }
            }
        }
        conn?.start(queue: .global())
    }

    /// receive data
    ///
    /// This will recursive until disconnect or error
    private func receiveData() {
        conn?.receive(minimumIncompleteLength: 0, maximumLength: 1024) { [weak self] content, _, _, recvError in
            guard let self else {
                return
            }

            if let err = recvError {
                if err == .posix(.ENODATA) {
                    DispatchQueue.main.async {
                        self.alertTitle = "connectServerDown".toNSL()
                        self.alertMsg = "connectServerDownHint".toNSL()
                        self.alertIsPresented = true
                    }
                }

                DispatchQueue.main.async {
                    self.disconnect()
                }
            } else {
                if let content, let data = try? JSONDecoder().decode(SystemInfo.self, from: content) {
                    DispatchQueue.main.async {
                        // usage
                        self.cpuUsage = data.cpu.cpuUsage / 100

                        // temperature
                        self.cpuTemp = data.cpu.cpuTemp?.roundTo(1) ?? 0

                        // freq
                        self.cpuFreq = data.cpu.cpuFreq.roundTo(2)

                        // memory
                        self.memUsage = data.mem.memUsage / 100

                        // network
                        let rawDlSpd = data.net.netDownload.parseMegaBytes()
                        let rawUlSpd = data.net.netUpload.parseMegaBytes()
                        if self.spdUnit == .MBs {
                            self.dlSpeed = rawDlSpd.roundTo(2)
                            self.ulSpeed = rawUlSpd.roundTo(2)
                        } else {
                            self.dlSpeed = (rawDlSpd * 8).roundTo(2)
                            self.ulSpeed = (rawUlSpd * 8).roundTo(2)
                        }

                        // other
                        self.uptime = data.other.upTime

                        // charts
                        self.list.append(.init(temp: self.cpuTemp,
                                               cpuUsage: self.cpuUsage * 100,
                                               memUsage: self.memUsage * 100,
                                               time: self.count))
                        self.count += 1
                        if self.count > 60 {
                            self.chartDelta += 1
                            self.list.removeFirst()
                        }
                    }
                }

                // redo rcv
                if self.connStatus == .connected {
                    self.receiveData()
                }
            }
        }
    }

    /**
     Connection
     */

    /// Connect
    func connect() {
        SavedUserDefaults.manualConn = true
        createConnection()
    }

    /// Disconnect
    func disconnect() {
        timer?.invalidate()
        SavedUserDefaults.manualConn = false
        if conn?.state == .ready || conn?.state == .preparing {
            conn?.forceCancel()
        }
        clearUi()
    }

    /// clear ui data
    private func clearUi() {
        cpuUsage = 0
        cpuTemp = 0
        cpuFreq = 0
        memUsage = 0
        dlSpeed = 0
        ulSpeed = 0
        uptime = "n/a".toNSL()
    }
}

enum ConnStatus {
    case disconnect
    case connecting
    case connected
}
