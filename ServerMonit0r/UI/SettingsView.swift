//
//  SettingsView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/4/1.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsData = SettingsData()
    @EnvironmentObject var serverData: ConnectionData

    @FocusState var ipFocus: Bool
    @FocusState var portFocus: Bool

    var body: some View {
        Form {
            Section("connSetting".toNSL()) {
                ConnField(title: "ip".toNSL(), value: $settingsData.ipValue, focus: $ipFocus, defValue: "127.0.0.1", kbType: .decimalPad)
                ConnField(title: "port".toNSL(), value: $settingsData.portValue, focus: $portFocus, defValue: "9943", kbType: .numberPad)
            }

            Section("prefSetting".toNSL()) {
                Toggle("srcAlwaysOn".toNSL(), isOn: $settingsData.scrAlwaysOn)
                Toggle("autoConnect".toNSL(), isOn: $settingsData.autoConnect)
                Picker("unit", selection: $settingsData.selUnit) {
                    ForEach(settingsData.unit, id: \.self) { i in
                        Text("\(i)")
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("settings".toNSL())
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Spacer()
                Button("save".toNSL()) {
                    settingsData.onSave()
                    if settingsData.checkInput() == .noError {
                        serverData.disconnect()
                    }
                }
                .alert(settingsData.alertTitle, isPresented: $settingsData.showAlert, actions: {
                    Button("ok".toNSL()) {}
                }, message: {
                    if let msg = settingsData.errMessage {
                        Text(msg)
                    }
                })
            }
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: {
                    ipFocus = true
                    portFocus = false
                }) {
                    Image(uiImage: UIImage(systemName: "chevron.up")!)
                }
                Button(action: {
                    ipFocus = false
                    portFocus = true
                }) {
                    Image(uiImage: UIImage(systemName: "chevron.down")!)
                }
                Spacer()
                Button("done".toNSL()) {
                    if ipFocus {
                        ipFocus = false
                    } else {
                        portFocus = false
                    }
                }
            }
        }
        .foregroundColor(.textColor)
    }
}

struct ConnField: View {
    var title: String
    var value: Binding<String>
    var focus: FocusState<Bool>.Binding
    let defValue: String
    let kbType: UIKeyboardType

    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
            }
            TextField(String(defValue), text: value)
                .font(.system(size: 18))
                .keyboardType(kbType)
                .foregroundColor(.textColor)
                .focused(focus)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
