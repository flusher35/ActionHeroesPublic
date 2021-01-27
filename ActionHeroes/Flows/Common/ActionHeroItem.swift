//
//  ActionHeroItem.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 26/01/2021.
//

struct ActionHeroItem: Identifiable, Hashable, Comparable {
    static func < (lhs: ActionHeroItem, rhs: ActionHeroItem) -> Bool {
        return lhs.name ?? "" < rhs.name ?? ""
    }

    let id: Int?
    let name: String?
    let description: String?
    let imageURL: ImageURL?

    init(from actionHero: ActionHero) {
        self.id = actionHero.id
        self.name = actionHero.name
        self.description = actionHero.description
        self.imageURL = ImageURL(from: actionHero.thumbnail)
    }
}
