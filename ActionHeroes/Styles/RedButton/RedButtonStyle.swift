//
//  RedButtonStyle.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 20/01/2021.
//

import SwiftUI

struct RedButtonStyle: ButtonStyle {

    let config: RedButtonStyleConfig

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.custom(.sfProTextSemibold, size: 17))
            .animation(nil)
            .lineLimit(1)
            .padding(.horizontal, 16)
            .frame(height: 43)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? config.backgroundPressedColor : config.backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(configuration.isPressed ? config.borderPressedColor : config.borderColor, lineWidth: 3)
                )
            .shadow(color: Color.buttonColor.opacity(0.5), radius: 16, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut)
    }
}
