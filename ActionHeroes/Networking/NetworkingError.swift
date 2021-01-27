//
//  NetworkingError.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Alamofire

enum NetworkingError: Error {
    case alamofire(AFError)
    case wrongURL

    var description: String {
        switch self {
        case .wrongURL: return "URL string is incorrect"
        case .alamofire(let error): return error.errorDescription ?? "Network error occured"
        }
    }
}
