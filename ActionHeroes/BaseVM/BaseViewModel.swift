//
//  BaseViewModel.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Combine

class BaseViewModel {
    // MARK: - Internal stored properties
    let errorHandler = ErrorHandler()
    var cancellableBag = Set<AnyCancellable>()
}
