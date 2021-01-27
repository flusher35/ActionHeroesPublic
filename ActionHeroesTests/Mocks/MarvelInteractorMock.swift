//
//  MarvelInteractorMock.swift
//  ActionHeroesTests
//
//  Created by Anton Shevtsov on 24/01/2021.
//

import Combine
import Foundation

final class MarvelInteractorMock: MarvelInteracting {
    var stubCharacters: [ActionHero]?
    var stubCharactersForSingleRequests: [ActionHero]?
    var getCharactersGotCalled: ((_ offset: Int) -> ())?

    func getCharacters(offset: Int, limit: Int) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError> {
        let baseResponse = BaseMarvelResponse(code: 200, data: BaseMarvelResponseData(offset: offset, limit: limit, total: 1800, count: limit, results: stubCharacters ?? ActionHeroStub.createRandomHeroes(limit)))
        getCharactersGotCalled?(offset)
        return Just(baseResponse)
            .setFailureType(to: NetworkingError.self)
            .delay(for: 0.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getCharacter(id: Int) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError> {
        let baseResponse = BaseMarvelResponse(code: 200, data: BaseMarvelResponseData(offset: 0, limit: 0, total: 0, count: 0, results: [stubCharactersForSingleRequests?.removeFirst() ?? ActionHeroStub.actionHeroStub]))
        getCharactersGotCalled?(0)
        return Just(baseResponse)
            .setFailureType(to: NetworkingError.self)
            .delay(for: 0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getCharacter(urlString: String) -> AnyPublisher<BaseMarvelResponse<[ActionHero]>, NetworkingError> {
        let baseResponse = BaseMarvelResponse(code: 200, data: BaseMarvelResponseData(offset: 0, limit: 0, total: 0, count: 0, results: [stubCharactersForSingleRequests?.removeFirst() ?? ActionHeroStub.actionHeroStub]))
        getCharactersGotCalled?(0)
        return Just(baseResponse)
            .setFailureType(to: NetworkingError.self)
            .delay(for: 0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
