//
//  CustomProgressbar.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/12/8.
//

import SwiftUI

struct CustomProgressbar: View {
    var progress: Double
    let minValue: Double
    let maxValue: Double
    var unit: String?
    @State var fontSize: CGFloat = 18
    @State var task: Task<Void, Never>?

    private let gradient = LinearGradient(stops: [.init(color: .gradientSevereStart, location: 0.5),
                                                  .init(color: .gradientSevereEnd, location: 0.9),
                                                  .init(color: .white.opacity(0), location: 1)],
                                          startPoint: .leading,
                                          endPoint: .trailing)

    var body: some View {
        VStack {
            HStack {
                Text(minValue.formatted() + " \(unit ?? "")")
                    .font(.custom("ZenDots-Regular", size: 18, relativeTo: .title3))
                Spacer()
                Text(maxValue.formatted() + " \(unit ?? "")")
                    .font(.custom("ZenDots-Regular", size: fontSize, relativeTo: .title3))
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
            .frame(minHeight: 32)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // background
                    Capsule()
                        .frame(width: geometry.size.width,
                               height: 24)
                        .foregroundColor(.gray.opacity(0.3))

                    // value
                    Capsule()
                        .frame(width: geometry.size.width * progress,
                               height: valueHeight(geometry.size.width * progress))
                        .foregroundStyle(gradient)
                }
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
        CustomProgressbar(progress: 0.05, minValue: 0, maxValue: 100, unit: "Mbps", fontSize: 1)
            .previewLayout(.fixed(width: 300, height: 60))
    }
}
