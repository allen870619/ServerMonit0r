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
            let list: [(name: String, list: [SystemInfoDataCell])] = [("os", data.osList),
                                                                      ("cpu", data.cpuList),
                                                                      ("memory", data.memList)]
            ForEach(list, id: \.self.name) { type in
                Section(content: {
                    ForEach(type.list) { item in
                        SingleSystemInfoView(title: item.title, value: item.value)
                    }
                }, header: {
                    Text(type.name)
                        .font(.title3)
                })
                .listRowBackground(Color.white.opacity(0.25))
            }

            // disk
            Section {
                List(data.diskList, children: \.list) { item in
                    SingleSystemInfoView(title: item.data.0, value: item.data.1)
                        .listRowBackground(Color.red)
                }
            } header: {
                Text("disk")
                    .font(.title3)
            }
            .listRowBackground(Color.white.opacity(0.25))
        }
        .refreshable {
            do {
                try await data.getData()
            } catch {
                data.errorMsg = error.localizedDescription
                data.errorAlert = true
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.backgroundColor)
        .navigationTitle("systemInfo".toNSL())
        .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)
        .alert("failed".toNSL(), isPresented: $data.errorAlert, actions: {
            Button("ok".toNSL()) {}
        }, message: {
            Text(data.errorMsg ?? "unknownError".toNSL())
        })
    }
}

struct SingleSystemInfoView: View {
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
        SystemInfoView(data: createMock())
    }

    static func createMock() -> SystemInfoViewModel {
        let viewModel = SystemInfoViewModel()
        viewModel.osList = [
            .init(title: "Test", value: "Value"),
            .init(title: "Test", value: "Value"),
            .init(title: "Test", value: "Value"),
        ]
        return viewModel
    }
}
