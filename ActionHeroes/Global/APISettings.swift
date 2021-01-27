//
//  APISettings.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 23/01/2021.
//

protocol APISettingsProvider {
    var publicKey: String { get }
    var privateKey: String { get }
}

struct APISettings: APISettingsProvider {
    let publicKey = "##### REPLACE WITH CORRECT PUBLIC KEY #####"
    let privateKey = "##### REPLACE WITH CORRECT PRIVATE KEY #####"
}
