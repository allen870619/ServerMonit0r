//
//  MainView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var connectionData: ConnectionData
    
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    CustomProgressView(title: "cpuUsage".toNSL(), percent: connectionData.cpuUsage)
                        .padding(.vertical, 16)
                    CustomProgressView(title: "cpuTemp".toNSL(), percent: connectionData.cpuTemp)
                        .padding(.vertical, 16)
                    CustomProgressView(title: "cpuFreq".toNSL(), percent: connectionData.cpuFreq)
                        .padding(.vertical, 16)
                    CustomProgressView(title: "memUsage".toNSL(), percent: connectionData.memUsage)
                        .padding(.vertical, 16)
                    CustomTextView(title: "uptime".toNSL(), value: connectionData.uptime)
                        .padding(.vertical, 16)
                    CustomTextView(title: "downloadSpd".toNSL(), value: connectionData.dlSpeed)
                        .padding(.vertical, 16)
                    CustomTextView(title: "uploadSpd".toNSL(), value: connectionData.ulSpeed)
                        .padding(.vertical, 16)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Server Monit0r")
            
            ZStack{
                Button(action: {
                    connectionData.onConnectClick()
                }, label: {
                    Text(connectionData.btnText)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                })
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
            .background(.blue)
        }.alert(connectionData.alertTitle, isPresented: $connectionData.alertIsPresented, actions: {
            Button("ok".toNSL()) { }
        }, message: {
            if let msg = connectionData.alertMsg{
                Text(msg)
            }
        })
    }
}

/**
 progress view
 */
struct CustomProgressView: View{
    var title: String = ""
    var percent: Double = 1.0
    
    var body: some View{
        VStack{
            Text(title)
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
                .frame(maxWidth:.infinity, alignment: .leading)
            GeometryReader(){geometer in // 用來測量框架大小的
                Rectangle()
                    .frame(height: 16)
                    .foregroundColor(.accentColor)
                    .cornerRadius(8)
                    .padding(.trailing, geometer.size.width * (1 - percent))
            }
        }
    }
}

/**
 text view
 */
struct CustomTextView: View{
    let title: String
    let value: String
    
    var body: some View{
        VStack{
            Text(title)
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
                .frame(maxWidth:.infinity, alignment: .leading)
            Text(value)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .frame(maxWidth:.infinity, alignment: .center)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ConnectionData())
    }
}
