//
//  MonitorGauge.swift
//  ServerMonit0r
//
//  Created by Lee Yen Lin on 2022/11/8.
//

import SwiftUI

struct MonitorGauge: View {
    var progress = 0.0
    var hint: String = ""

    var body: some View {
        ZStack {
            Gauge(value: progress) {} currentValueLabel: {
                Text(progress.roundTo(3).formatted(.percent))
            }
            .gaugeStyle(SpeedoGaugeStyle(hint: hint))
            .tint(.blue)
            .padding(16)
        }
    }
}

struct SpeedoGaugeStyle: GaugeStyle {
    private var purpleGradient = LinearGradient(gradient: Gradient(colors: [.gradientStart,
                                                                            .gradientMiddle,
                                                                            .gradientEnd]),
    startPoint: .trailing,
    endPoint: .leading)
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
                        style: .init(lineWidth: 16,
                                     lineCap: .round))
                .rotationEffect(.degrees(135))

            // value
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(purpleGradient, style: .init(lineWidth: 16, lineCap: .round))
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
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                Text(hint)
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MonitorGauge_Previews: PreviewProvider {
    static var previews: some View {
        MonitorGauge(progress: 0.4, hint: "test").previewLayout(.fixed(width: 300, height: 300))
    }
}
