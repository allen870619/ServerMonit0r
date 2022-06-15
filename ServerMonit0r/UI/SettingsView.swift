//
//  SettingsView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/4/1.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var data = SettingsData()
    
    @FocusState var ipFocus: Bool
    @FocusState var portFocus: Bool
    
    var body: some View {
        Form{
            Section("connSetting".toNSL()){
                IpPack(ipValue: $data.ipValue, ipFocus: $ipFocus)
                PortPack(portValue: $data
                    .portValue, portFocus: $portFocus)
            }
            
            Section("prefSetting".toNSL()){
                Toggle("srcAlwaysOn".toNSL(), isOn: $data.scrAlwaysOn)
                Toggle("autoConnect".toNSL(), isOn: $data.autoConnect)
                Picker("unit", selection: $data.selUnit){
                    ForEach(data.unit, id: \.self){ i in
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
                    data.onSave()
                }.alert(data.alertTitle, isPresented: $data.showAlert, actions: {
                    Button("ok".toNSL()) { }
                }, message: {
                    if let msg = data.errMessage{
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
        SettingsView()
    }
}
