//
//  ActionHeroStub.swift
//  ActionHeroesTests
//
//  Created by Anton Shevtsov on 24/01/2021.
//

struct ActionHeroStub {

    static let actionHeroStub = ActionHero(id: 235235, name: "Robin", description: "Robin has no description", resourceURI: "https://www.marvel.com/hero/robin/landingpage", thumbnail: ActionHeroThumbnail(path: "https://www.marvel.com/hero/robin", extension: "jpeg"))

    static let actionHeroStub2 = ActionHero(id: 4217, name: "Batman", description: "Batman Forever", resourceURI: "https://www.marvel.com/hero/batman/forever", thumbnail: ActionHeroThumbnail(path: "https://www.marvel.com/hero/batman", extension: "jpeg"))

    static func createRandomHeroes(_ count: Int) -> [ActionHero] {
        var array = [ActionHero]()
        (0..<count).forEach { _ in array.append(ActionHero(id: Int.random(in: 10000...999999), name: "RandomHero", description: "RandomDescription", resourceURI: "https://www.marvel.com/hero/awesomehero/landingpage", thumbnail: ActionHeroThumbnail(path: "https://www.marvel.com/hero/awesomehero", extension: "jpeg"))) }
        return array
    }
}
