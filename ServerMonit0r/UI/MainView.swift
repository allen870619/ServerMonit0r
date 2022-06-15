//
//  MainView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var serverData = ServerData()
    
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    MyProgressView(title: "Cpu Usage", percent: serverData.cpuUsage)
                        .padding(.vertical, 16)
                    MyProgressView(title: "Cpu Temp", percent: serverData.cpuTemp)
                        .padding(.vertical, 16)
                    MyProgressView(title: "Cpu Freq", percent: serverData.cpuFreq)
                        .padding(.vertical, 16)
                    MyProgressView(title: "Mem Usage", percent: serverData.memUsage)
                        .padding(.vertical, 16)
                    VStack{
                        Text("Up time")
                            .font(.system(size: 18))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth:.infinity, alignment: .leading)
                        Text(serverData.upTime)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth:.infinity, alignment: .center)
                    }.padding(.vertical, 16)
                }
            }
            Spacer()
            Button(action: {
                serverData.onConnectClick()
            }, label: {
                Text(serverData.btnText)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }).padding(32)
            
        }.padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .navigationTitle("Server Monit0r")
    }
}

struct MyProgressView: View{
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

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView()
    }
}
