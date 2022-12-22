//
//  CustomTextView.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/22.
//

import SwiftUI

struct CustomTextView: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.textColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .font(.custom("ZenDots-Regular", size: 18))
                .foregroundColor(.textColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct CustomTextView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextView(title: "_Title", value: "asdasda")
    }
}
