//
//  UserDefaults.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 21/01/2021.
//

import Foundation

extension UserDefaults {
    @objc dynamic var hiredHeroIDs: [Int] {
        get { array(forKey: UserDefaults.hiredHeroIDsKey) as? [Int] ?? [] }
        set { setValue(newValue, forKey: UserDefaults.hiredHeroIDsKey) }
    }
}

extension UserDefaults {
    static let hiredHeroIDsKey = "hiredHeroIDs"
}
