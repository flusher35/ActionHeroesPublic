//
//  BaseMarvelResponse.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

struct BaseMarvelResponse<T: Decodable>: Decodable {
    let code: Int
    let data: BaseMarvelResponseData<T>
}
