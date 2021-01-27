//
//  MarvelInteractor.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Combine

protocol MarvelInteracting {
    func getCharacters(offset: Int, limit: Int) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError>
    func getCharacter(id: Int) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError>
    func getCharacter(urlString: String) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError>
}

class MarvelInteractor: MarvelInteracting {

    // MARK: - Private stored properties
    private let networkManager: NetworkManager

    // MARK: - Internal methods
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getCharacters(offset: Int, limit: Int) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError> {
        let parameters = [RequestParameter.offset: String(offset),
                          RequestParameter.limit: String(limit)]
        return networkManager.request("https://gateway.marvel.com/v1/public/characters", method: .get, parameters: parameters)
    }

    func getCharacter(id: Int) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError> {
        return networkManager.request("https://gateway.marvel.com/v1/public/characters/\(id)", method: .get)
    }

    func getCharacter(urlString: String) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError> {
        return networkManager.request(urlString, method: .get)
    }
}
