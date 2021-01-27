//
//  Collection+Extension.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 26/01/2021.
//

extension Collection where Element: Equatable {
    func contains(_ member: Element?) -> Bool {
        guard let member = member else { return false }
        return contains(member)
    }
}
