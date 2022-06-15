//
//  MenuView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/3/31.
//

import SwiftUI

struct MenuView: View {
    @State private var selection: String? = "dashboard".toNSL()
    let list: [String] = ["dashboard".toNSL(), "settings".toNSL()]
    
    var body: some View {
        NavigationView {
            List(list, id: \.self){ element in
                NavigationLink(tag: element, selection: $selection, destination: {
                    if selection == "dashboard".toNSL(){
                        MainView()
                    }else{
                        SettingsView()
                    }
                }, label: {
                    Text(element)
                })
            }
            .navigationTitle("menu".toNSL())
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
