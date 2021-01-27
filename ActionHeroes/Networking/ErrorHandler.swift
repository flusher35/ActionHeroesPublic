//
//  ErrorHandler.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Combine

class ErrorHandler {

    // MARK: - Internal stored properties
    let errorSubject = PassthroughSubject<NetworkingError, Never>()

    // MARK: - Internal methods
    deinit {
        errorSubject.send(completion: .finished)
    }

    func handleErrors<T: Publisher>(from publisher: T) -> AnyPublisher<T.Output, Never> where T.Failure == NetworkingError {
        publisher.catch { [weak self] error -> Combine.Empty<T.Output, Never> in
            self?.errorSubject.send(error)
            return .init()
        }
        .eraseToAnyPublisher()
    }
}
