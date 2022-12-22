//
//  CustomProgressbar.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/8.
//

import SwiftUI

struct CustomProgressbar: View {
    let title: String
    let value: Double
    let unit: String?
    var minVal: Double = 0
    var maxVal: Double = 1

    @State private var fontSize: CGFloat = 18
    @State private var task: Task<Void, Never>?
    @State private var overHint = ""

    private let gradient = LinearGradient(stops: [.init(color: .gradientSevereStart, location: 0.4),
                                                  .init(color: .gradientSevereEnd, location: 0.8),
                                                  .init(color: .white.opacity(0), location: 1)],
                                          startPoint: .leading,
                                          endPoint: .trailing)

    var body: some View {
        VStack(alignment: .leading) {
            // title
            Text(title)

            // center value
            HStack {
                Text(minVal.formatted())
                    .font(.custom("ZenDots-Regular", size: 18, relativeTo: .title3))
                    .frame(width: 80, alignment: .leading)

                Text(value.formatted() + " \(unit ?? "")")
                    .font(.custom("ZenDots-Regular", size: 18, relativeTo: .title3))
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(maxVal.formatted() + overHint)
                    .font(.custom("ZenDots-Regular", size: fontSize, relativeTo: .title3))
                    .frame(width: 80, alignment: .trailing)
                    .animation(.linear(duration: 0.1), value: fontSize)
                    .onChange(of: value) { newValue in
                        if calProgress(newValue) >= 1 {
                            if task == nil {
                                task = Task {
                                    overHint = "+"
                                    await self.wiggle()
                                }
                            }
                        } else {
                            overHint = ""
                            if task != nil {
                                task?.cancel()
                                task = nil
                            }
                        }
                    }
            }
            .frame(maxWidth: .infinity, minHeight: 32)

            // progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // background
                    Capsule()
                        .frame(width: geometry.size.width,
                               height: 24)
                        .foregroundColor(.gray.opacity(0.3))

                    // value
                    Rectangle()
                        .frame(width: geometry.size.width * progressVal,
                               height: 24)
                        .foregroundStyle(gradient)
                        .animation(.default, value: progressVal)
                }.cornerRadius(12)
            }
        }
    }

    private var progressVal: Double {
        min(1, (value - minVal) / (maxVal - minVal))
    }

    private func calProgress(_ val: Double) -> Double {
        min(1, (val - minVal) / (maxVal - minVal))
    }

    // blink max value
    private func wiggle() async {
        while true {
            do {
                fontSize = 24
                try await Task.sleep(nanoseconds: 100_000_000)
                fontSize = 18
                try await Task.sleep(nanoseconds: 200_000_000)
            } catch {
                fontSize = 18
                break
            }
        }
    }
}

struct CustomProgressbar_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressbar(title: "Download Speed", value: 5.5, unit: "Mbps", maxVal: 10)
            .previewLayout(.fixed(width: 300, height: 120))
    }
}
