//
//  PressButtonStyle.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 20/01/2021.
//

import SwiftUI

struct PressButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut)
    }
}
