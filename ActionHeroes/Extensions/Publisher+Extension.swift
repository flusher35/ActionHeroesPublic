//
//  Publisher+Extension.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Combine

extension Publisher {
    func handleErrors(_ errorHandler: ErrorHandler) -> AnyPublisher<Output, Never> where Self.Failure == NetworkingError {
        errorHandler.handleErrors(from: self)
    }

    func assign<S: Subject>(toSubject: S?) -> AnyCancellable where S.Output == Self.Output, Self.Failure == Never {
        self.sink { [weak toSubject] in
            toSubject?.send($0)
        }
    }
}

extension Publisher where Failure == Never {
    func assignNoRetain<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }

    func assignOptionalNoRetain<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output?>, on object: Root) -> AnyCancellable {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}
