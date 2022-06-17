//
//  SettingsView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/4/1.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsData = SettingsData()
    @ObservedObject var serverData: ConnectionData
    
    @FocusState var ipFocus: Bool
    @FocusState var portFocus: Bool
    
    var body: some View {
        Form{
            Section("connSetting".toNSL()){
                IpPack(ipValue: $settingsData.ipValue, ipFocus: $ipFocus)
                PortPack(portValue: $settingsData
                    .portValue, portFocus: $portFocus)
            }
            
            Section("prefSetting".toNSL()){
                Toggle("srcAlwaysOn".toNSL(), isOn: $settingsData.scrAlwaysOn)
                Toggle("autoConnect".toNSL(), isOn: $settingsData.autoConnect)
                Picker("unit", selection: $settingsData.selUnit){
                    ForEach(settingsData.unit, id: \.self){ i in
                        Text("\(i)")
                    }
                }.pickerStyle(.segmented)
            }
        }
        .navigationTitle("settings".toNSL())
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Spacer()
                Button("save".toNSL()){
                    settingsData.onSave()
                    if settingsData.checkInput() == .noError{
                        serverData.resetConnect()
                    }
                }.alert(settingsData.alertTitle, isPresented: $settingsData.showAlert, actions: {
                    Button("ok".toNSL()) { }
                }, message: {
                    if let msg = settingsData.errMessage{
                        Text(msg)
                    }
                })
            }
            ToolbarItemGroup(placement: .keyboard){
                Button(action: {
                    ipFocus = true
                    portFocus = false
                }){
                    Image(uiImage: UIImage(systemName: "chevron.up")!)
                }
                Button(action: {
                    ipFocus = false
                    portFocus = true
                }){
                    Image(uiImage: UIImage(systemName: "chevron.down")!)
                }
                Spacer()
                Button("done".toNSL()){
                    if ipFocus{
                        ipFocus = false
                    }else{
                        portFocus = false
                    }
                }
            }
        }
    }
}

struct IpPack: View{
    var ipValue: Binding<String>
    var ipFocus: FocusState<Bool>.Binding
    let ipDefault = "127.0.0.1"
    
    var body: some View {
        VStack{
            HStack{
                Text("ip".toNSL())
                Spacer()
            }
            TextField(ipDefault, text: ipValue)
                .font(.system(size: 18))
                .keyboardType(.decimalPad)
                .focused(ipFocus)
        }
        .padding(.vertical, 4)
    }
}

struct PortPack: View{
    var portValue: Binding<String>
    var portFocus: FocusState<Bool>.Binding
    let portDefault = 9943
    
    var body: some View {
        VStack{
            HStack{
                Text("port".toNSL())
                Spacer()
            }
            TextField(String(portDefault), text: portValue)
                .font(.system(size: 18))
                .keyboardType(.numberPad)
                .focused(portFocus)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(serverData: ConnectionData())
    }
}
