//
//  ActionHero.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Foundation

struct ActionHero: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let resourceURI: String?
    let thumbnail: ActionHeroThumbnail?
}
