//
//  CustomProgressbar.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/8.
//

import SwiftUI

struct CustomProgressbar: View {
    let progress: Double
    let minValue: Double
    let maxValue: Double

    private let gradient = LinearGradient(stops: [.init(color: .gradientSevereStart, location: 0.5),
                                                  .init(color: .gradientSevereEnd, location: 0.9),
                                                  .init(color: .white.opacity(0), location: 1)],
                                          startPoint: .leading,
                                          endPoint: .trailing)

    var body: some View {
        VStack {
            HStack {
                Text(minValue.formatted())
                Spacer()
                Text(maxValue.formatted())
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // background
                    Capsule()
                        .frame(width: geometry.size.width,
                               height: 24)
                        .foregroundColor(.gray.opacity(0.3))
                    Capsule()
                        .frame(width: geometry.size.width * progress,
                               height: valueHeight(geometry.size.width * progress))
                        .foregroundStyle(gradient)
                }
            }
        }
    }

    /// calculate the height of value bar
    private func valueHeight(_ posX: Double) -> Double {
        if posX >= 12 {
            return 24
        }

        let result = sqrt(posX * (24 - posX)) * 2
        if result < 0 || result == .nan {
            return 0
        }
        return result
    }
}

struct CustomProgressbar_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressbar(progress: 0.05, minValue: 0, maxValue: 100)
            .previewLayout(.fixed(width: 300, height: 60))
    }
}
