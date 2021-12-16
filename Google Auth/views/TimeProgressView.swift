//
//  ProgressView.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 16.09.2021.
//

import SwiftUI

struct TimeProgressView: View {
    @Binding var value: Int
    @Binding var color: Color
    let maxValue: Int
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .padding()
            Text(String(maxValue - value))
                .font(.title)
        }
    }
    
    private func calculateTrimmingFor(_ value: Int) -> CGFloat {
        return CGFloat(value) / CGFloat(maxValue)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TimeProgressView(value: Binding.constant(17), color: Binding.constant(.orange), maxValue: CODE_LIFE_SECONDS)
            .frame(width: 100, height: 100, alignment: .leading)
    }
}
