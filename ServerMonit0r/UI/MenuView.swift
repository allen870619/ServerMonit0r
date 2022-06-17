//
//  MenuView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/31.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var serverData: ConnectionData
    @State private var selection : String? = "dashboard".toNSL()
    let menuList = ["dashboard".toNSL(), "settings".toNSL()]
    
    var body: some View {
        NavigationView{
            List(menuList, id: \.self){ element  in
                NavigationLink(tag: element, selection: $selection){
                    if selection == "dashboard".toNSL(){
                        MainView()
                    }else{
                        SettingsView(serverData: serverData)
                    }
                } label: {
                    Text(element)
                }
                .navigationTitle("menu".toNSL())
            }
        }
    }
}

extension View {
    func customNavStyle() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(.columns))
        } else {
            if UIDevice.current.orientation == .portrait{
                return AnyView(self.navigationViewStyle(.stack))
            }else{
                return AnyView(self.navigationViewStyle(.columns))
            }
            
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(ConnectionData())
            .previewInterfaceOrientation(.landscapeRight)
    }
}
