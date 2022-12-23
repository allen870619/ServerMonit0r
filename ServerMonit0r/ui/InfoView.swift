//
//  InfoView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/22.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                Text("aboutServer".toNSL())
                    .font(.numFontWithChinese(size: 24))
                Text("aboutServerContent".toNSL())
                    .font(.numFontWithChinese(size: 18))
                Link("aboutClick".toNSL(), destination: .init(string: "https://github.com/allen870619/ServerMonit0r-server")!)

                Spacer().frame(height: 32)
                Text("aboutCreator".toNSL())
                    .font(.numFontWithChinese(size: 24))
                Text("Allen Lee")
                    .font(.numFontWithChinese(size: 18))
                HStack(spacing: 16) {
                    IconLinkView(url: URL(string: "https://github.com/allen870619"),
                                 imgName: "ic_github")

                    IconLinkView(url: URL(string: "https://twitter.com/FLHuaHua"), imgName: "ic_twitter")

                    if let generalMail = URL(string: "mailto://allen870619@gmail.com") {
                        IconLinkView(url: generalMail, imgName: "ic_gmail")
                    } else {
                        IconLinkView(url: nil, imgName: "ic_gmail") {
                            UIPasteboard.general.string = "allen870619@gmail.com"
                        }
                    }
                }
                .frame(height: 36)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.backgroundColor)
        .navigationTitle("about".toNSL())
        .toolbarBackground(Color.accentColor.opacity(0.5), for: .navigationBar)
    }
}

struct IconLinkView: View {
    var url: URL?
    var imgName: String
    var action: (() -> Void)?
    var body: some View {
        if let url {
            Link(destination: url) {
                Image(imgName, bundle: .main)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
            }
        } else {
            Button(action: {
                action?()
            }, label: {
                Image(imgName, bundle: .main)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
            })
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
