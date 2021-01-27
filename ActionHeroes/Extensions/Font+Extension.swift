//
//  Font+Extension.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import SwiftUI

enum CustomFont: String {
    case sfProTextSemibold = "SFProText-Semibold"
    case sfProTextRegular = "SFProText-Regular"
    case sfProDisplaySemibold = "SFProDisplay-Semibold"
    case sfProDisplayBold = "SFProDisplay-Bold"
}

extension Font {
    static func custom(_ font: CustomFont, size: CGFloat) -> Font {
        return Font.custom(font.rawValue, size: size)
    }
}
