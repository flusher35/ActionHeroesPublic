//
//  ConfirmModalViewModel.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 23/01/2021.
//

import Combine

class ConfirmModalViewModel: ObservableObject {
    // MARK: - Internal stored properties
    let text: String
    let yesButtonText: String
    let noButtonText: String
    let resultSubject = PassthroughSubject<Bool, Never>()

    // MARK: - Internal methods
    init(text: String,
         yesButtonText: String,
         noButtonText: String) {
        self.text = text
        self.yesButtonText = yesButtonText
        self.noButtonText = noButtonText
    }

    deinit {
        resultSubject.send(completion: .finished)
    }
}
