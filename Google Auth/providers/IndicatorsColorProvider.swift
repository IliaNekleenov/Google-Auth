//
//  IndicatorsProvider.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 16.09.2021.
//

import Foundation
import SwiftUI

fileprivate typealias ColorComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat)

class IndicatorsColorProvider {
    private let startColor: ColorComponents
    private let endColor: ColorComponents
    private let maxSeconds: Int
    var onNewSecond: (Int, Color) -> Void
    
    var secondsPassed: Int
    var indicatorsColor: Color
        
    init(startColor: Color, endColor: Color, maxSeconds: Int, onNewSecond: @escaping (Int, Color) -> Void) {
        self.startColor = startColor.components
        self.endColor = endColor.components
        self.secondsPassed = Calendar.current.component(.second, from: Date()) % CODE_LIFE_SECONDS
        self.maxSeconds = maxSeconds
        self.onNewSecond = onNewSecond
        self.indicatorsColor = IndicatorsColorProvider.calculateIndicatorsColor(startColor: self.startColor, endColor: self.endColor, secondsPassed: secondsPassed, maxSeconds: maxSeconds)
        self.onNewSecond(secondsPassed, indicatorsColor)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            let seconds = Calendar.current.component(.second, from: Date()) % CODE_LIFE_SECONDS
            let indicatorsColor = IndicatorsColorProvider.calculateIndicatorsColor(startColor: self.startColor, endColor: self.endColor, secondsPassed: seconds, maxSeconds: maxSeconds)
            self.secondsPassed = seconds
            self.indicatorsColor = indicatorsColor
            self.onNewSecond(seconds, indicatorsColor)
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    private static func calculateIndicatorsColor(startColor: ColorComponents, endColor: ColorComponents, secondsPassed: Int, maxSeconds: Int) -> Color {
        let passed = CGFloat(secondsPassed) / CGFloat(maxSeconds)
        
        let redDelta = (endColor.red - startColor.red) * passed
        let greenDelta = (endColor.green - startColor.green) * passed
        let blueDelta = (endColor.blue - startColor.blue) * passed
        let opDelta = (endColor.opacity - startColor.opacity) * passed

        return Color.init(
            red: Double(startColor.red + redDelta),
            green: Double(startColor.green + greenDelta),
            blue: Double(startColor.blue + blueDelta),
            opacity: Double(startColor.opacity + opDelta)
        )
    }
    
}

extension Color {
    fileprivate var components: ColorComponents {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        return (r, g, b, o)
    }
}
