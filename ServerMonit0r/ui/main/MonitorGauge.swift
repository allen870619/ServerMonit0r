//
//  MonitorGauge.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/11/8.
//

import SwiftUI

struct MonitorGauge: View {
    var value: Double
    var hint: String = ""
    var type: GaugeType = .raw

    /// calculate percentage of value
    ///
    /// depends on type
    private var progress: Double {
        var tmpValue = value
        switch type {
        case .percent:
            return tmpValue
        case .temp:
            tmpValue /= 100
        case .freq:
            tmpValue -= 800
            tmpValue /= 6000
        case .raw:
            break
        }

        // check bound
        if tmpValue > 1 {
            return 1
        } else if tmpValue < 0 {
            return 0
        }
        return tmpValue
    }

    var body: some View {
        ZStack {
            Gauge(value: progress) {} currentValueLabel: {
                getText()
            }
            .gaugeStyle(SpeedoGaugeStyle(hint: hint))
            .tint(.blue)
            .padding(16)
        }
    }

    func getText() -> Text {
        switch type {
        case .percent:
            return Text(value.roundTo(3).formatted(.percent))
        case .temp:
            return Text("\(value.roundTo(2).formatted()) ºC")
        case .freq:
            return Text("\(value.rounded().formatted())")
        default:
            return Text("\(value)")
        }
    }
}

struct SpeedoGaugeStyle: GaugeStyle {
    private var normalGradient = LinearGradient(
        gradient: Gradient(colors: [
            .gradientNormalStart,
            .gradientNormalEnd,
        ]),
        startPoint: .trailing,
        endPoint: .leading
    )

    private var fairGradient = LinearGradient(
        gradient: Gradient(colors: [
            .gradientFairStart,
            .gradientFairEnd,
        ]),
        startPoint: .trailing,
        endPoint: .leading
    )

    private var severeGradient = LinearGradient(
        gradient: Gradient(colors: [
            .gradientSevereStart,
            .gradientSevereEnd,
        ]),
        startPoint: .trailing,
        endPoint: .leading
    )
    var hint: String

    init(hint: String) {
        self.hint = hint
    }

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            // background
            Circle()
                .foregroundColor(Color(.systemGray6.withAlphaComponent(0.5)))

            // measure background
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color(.systemGray4),
                        style: .init(lineWidth: 12,
                                     lineCap: .round))
                .rotationEffect(.degrees(135))

            // value
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(getGradient(configuration.value), style: .init(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(135))
                .animation(.default, value: configuration.value)

            // measure
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.white.opacity(0.75), style: StrokeStyle(lineWidth: 12,
                                                                      lineCap: .butt,
                                                                      lineJoin: .round,
                                                                      dash: [1, 30],
                                                                      dashPhase: 0.0))
                .rotationEffect(.degrees(135))

            VStack {
                configuration.currentValueLabel
                    .font(.custom("ZenDots-Regular", size: 24, relativeTo: .title))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                if !hint.isEmpty {
                    Text(hint)
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                }
            }
        }
    }

    func getGradient(_ percent: Double) -> LinearGradient {
        if percent < 0.4 {
            return normalGradient
        } else if percent < 0.8 {
            return fairGradient
        } else {
            return severeGradient
        }
    }
}

enum GaugeType {
    case percent
    case temp
    case freq
    case raw
}

struct MonitorGauge_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonitorGauge(value: 0.3, hint: "test", type: .raw)
                .previewLayout(.sizeThatFits)
        }
    }
}
