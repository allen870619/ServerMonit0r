//
//  SystemInfoView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/13.
//

import SwiftUI

struct SystemInfoView: View {
    @StateObject var data = SystemInfoViewModel()

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

            Section {
                List(data.diskList, children: \.list) { item in
                    InfoView(title: item.data.0, value: item.data.1)
                        .listRowBackground(Color.red)
                }
            } header: {
                Text("disk")
                    .font(.title3)
            }
        }
        .refreshable {
            do {
                try await data.getData()
            } catch {
                data.errorMsg = error.localizedDescription
                data.errorAlert = true
            }
        }
        .navigationTitle("systemInfo".toNSL())
        .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)
        .alert("failed".toNSL(), isPresented: $data.errorAlert, actions: {
            Button("ok".toNSL()) {}
        }, message: {
            Text(data.errorMsg ?? "unknownError".toNSL())
        })
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
