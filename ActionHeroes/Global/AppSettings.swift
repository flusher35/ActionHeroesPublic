//
//  AppSettings.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 21/01/2021.
//

import Combine
import Foundation

protocol ActionHeroHiringProviding {
    var hiredHeroesIDsPublisher: AnyPublisher<[Int], Never> { get }
    var hiredHeroesModifyIDsSubject: PassthroughSubject<ArrayItemModifier<Int>, Never> { get }
}

class AppSettings: ActionHeroHiringProviding {

    static let shared = AppSettings()

    // MARK: - Internal computed properties
    var hiredHeroesIDsPublisher: AnyPublisher<[Int], Never> {
        return userDefaults.publisher(for: \.hiredHeroIDs)
            .eraseToAnyPublisher()
    }

    // MARK: - Internal stored properties
    let hiredHeroesModifyIDsSubject = PassthroughSubject<ArrayItemModifier<Int>, Never>()

    // MARK: - Private stored properties
    private let userDefaults: UserDefaults = UserDefaults.standard
    private var cancellableBag = Set<AnyCancellable>()

    // MARK: - Private methods
    private init() {
        setupBindings()
    }

    private func setupBindings() {
        hiredHeroesModifyIDsSubject
            .combineLatest(hiredHeroesIDsPublisher)
            .map {
                var heroSet = Set($0.1)
                switch $0.0 {
                case .add(let id): heroSet.update(with: id)
                case .remove(let id): heroSet.remove(id)
                }
                return Array(heroSet)
            }
            .assignNoRetain(to: \.hiredHeroIDs, on: userDefaults)
            .store(in: &cancellableBag)
    }
}
