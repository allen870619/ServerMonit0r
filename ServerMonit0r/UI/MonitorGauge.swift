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
            return Text("\(value.rounded().formatted()) MHz")
        default:
            return Text("\(value)")
        }
    }
}

struct SpeedoGaugeStyle: GaugeStyle {
    private var purpleGradient = LinearGradient(
        gradient: Gradient(colors: [
            .gradientStart,
            .gradientMiddle,
            .gradientEnd,
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
                .stroke(purpleGradient, style: .init(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(135))

            // measure
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 12,
                                                       lineCap: .butt,
                                                       lineJoin: .round,
                                                       dash: [1, 30],
                                                       dashPhase: 0.0))
                .rotationEffect(.degrees(135))

            VStack {
                configuration.currentValueLabel
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                if !hint.isEmpty {
                    Text(hint)
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                }
            }
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
        MonitorGauge(value: 0.3, hint: "test", type: .raw).previewLayout(.fixed(width: 300, height: 300))
    }
}
