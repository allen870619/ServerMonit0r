//
//  SystemInfoView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/13.
//

import SwiftUI

struct SystemInfoView: View {
    @StateObject var data = SystemInfoData()

    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 160)), count: 2)

    var body: some View {
        Form {
            Section(content: {
                ForEach(data.osList, id: \.self.0) { item in
                    InfoView(title: item.0, value: item.1)
                }
            }, header: {
                Text("OS")
                    .font(.title3)
            })

            Section(content: {
                ForEach(data.cpuList, id: \.self.0) { item in
                    InfoView(title: item.0, value: item.1)
                }
            }, header: {
                Text("CPU")
                    .font(.title3)
            })

            Section(content: {
                ForEach(data.memList, id: \.self.0) { item in
                    InfoView(title: item.0, value: item.1)
                }
            }, header: {
                Text("MEMORY")
                    .font(.title3)
            })

            ForEach(data.diskList, id: \.self.device) { item in
                Section(content: {
                    ForEach(item.dataList, id: \.self.0) { disk in
                        InfoView(title: disk.0, value: disk.1)
                    }
                }, header: {
                    Text(item.device)
                        .font(.title3)
                })
            }
        }
        .refreshable(action: data.getData)
        .navigationTitle("systemInfo".toNSL())
        .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)
    }
}

struct InfoView: View {
    var title: String
    var value: String?

    var body: some View {
        VStack {
            HStack {
                Text(title.toNSL())
                Spacer()
            }
            Text(value ?? "n/a".toNSL())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
    }
}

struct SystemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SystemInfoView()
    }
}
