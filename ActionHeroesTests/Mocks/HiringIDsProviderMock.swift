//
//  HiringIDsProviderMock.swift
//  ActionHeroesTests
//
//  Created by Anton Shevtsov on 24/01/2021.
//

import Combine

class HiringIDsProviderMock: ActionHeroHiringProviding {
    let stubHiredIDsSubject = PassthroughSubject<[Int?], Never>()
    let mockToModifyHiredIDsSubject = PassthroughSubject<ArrayItemModifier<Int>, Never>()

    var hiredHeroesIDsPublisher: AnyPublisher<[Int], Never> {
        return stubHiredIDsSubject
            .map { $0.compactMap { $0 } }
            .eraseToAnyPublisher()
    }

    var hiredHeroesModifyIDsSubject: PassthroughSubject<ArrayItemModifier<Int>, Never> {
        return mockToModifyHiredIDsSubject
    }
}
