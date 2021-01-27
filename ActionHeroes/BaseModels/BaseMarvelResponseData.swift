//
//  BaseMarvelResponseData.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

struct BaseMarvelResponseData<T: Decodable>: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: T
}
