//
//  RedButtonStyleConfig.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 20/01/2021.
//

import SwiftUI

enum RedButtonStyleConfig {
    case primary
    case secondary

    // MARK: - Internal computed properties
    var backgroundColor: Color? {
        switch self {
        case .primary: return .buttonColor
        case .secondary: return Color.buttonColor.opacity(0.01)
        }
    }

    var backgroundPressedColor: Color? {
        switch self {
        case .primary: return .buttonPressedColor
        case .secondary: return Color.buttonColor.opacity(0.01)
        }
    }

    var borderColor: Color {
        switch self {
        case .primary: return .buttonColor
        case .secondary: return .buttonColor
        }
    }

    var borderPressedColor: Color {
        switch self {
        case .primary: return .buttonPressedColor
        case .secondary: return .buttonPressedColor
        }
    }
}
