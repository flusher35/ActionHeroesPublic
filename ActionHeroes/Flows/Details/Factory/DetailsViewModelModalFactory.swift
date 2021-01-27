//
//  DetailsViewModelModalFactory.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 24/01/2021.
//

protocol DetailsViewModelModalFactoryProviding {
    func createConfirmModalViewModel(text: String) -> ConfirmModalViewModel
}

class DetailsViewModelModalFactory: DetailsViewModelModalFactoryProviding {
    func createConfirmModalViewModel(text: String) -> ConfirmModalViewModel {
        return ConfirmModalViewModel(text: text,
                                     yesButtonText: Strings.yes.uppercased(),
                                     noButtonText: Strings.oopsNo.uppercased())
    }
}
