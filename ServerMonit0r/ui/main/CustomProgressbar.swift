//
//  CustomProgressbar.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/8.
//

import SwiftUI

struct CustomProgressbar: View {
    let title = "Title"
    let value = 1234
    let unit = "Mbps"
    var progress: Double
    let minValue: Double
    let maxValue: Double
    @State private var fontSize: CGFloat = 18
    @State private var task: Task<Void, Never>?
    private let gradient = LinearGradient(stops: [.init(color: .gradientSevereStart, location: 0.4),
                                                  .init(color: .gradientSevereEnd, location: 0.8),
                                                  .init(color: .white.opacity(0), location: 1)],
                                          startPoint: .leading,
                                          endPoint: .trailing)

    var body: some View {
        VStack(alignment: .leading) {
            // title
            Text("Title")

            // center value

            HStack {
                Text(minValue.formatted())
                    .font(.custom("ZenDots-Regular", size: 18, relativeTo: .title3))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(value.formatted() + "\(unit)")
                    .font(.custom("ZenDots-Regular", size: 18, relativeTo: .title3))
                    .frame(maxWidth: .infinity, alignment: .center)

                Text(maxValue.formatted())
                    .font(.custom("ZenDots-Regular", size: fontSize, relativeTo: .title3))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .animation(.linear(duration: 0.1), value: fontSize)
                    .onChange(of: progress) { newValue in
                        if newValue >= 1 {
                            if task == nil {
                                task = Task {
                                    await self.wiggle()
                                }
                            }
                        } else {
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
                        .frame(width: geometry.size.width * progress,
                               height: 24)
                        .foregroundStyle(gradient)
                        .animation(.default, value: progress)
                }.cornerRadius(12)
            }
        }
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
        CustomProgressbar(progress: 0.5, minValue: 0, maxValue: 100)
            .previewLayout(.fixed(width: 300, height: 120))
    }
}
