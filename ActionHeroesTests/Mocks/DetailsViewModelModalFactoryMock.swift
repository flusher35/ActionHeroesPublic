//
//  DetailsViewModelModalFactoryMock.swift
//  ActionHeroesTests
//
//  Created by Anton Shevtsov on 26/01/2021.
//

import Combine

class DetailsViewModelModalFactoryMock: DetailsViewModelModalFactoryProviding {

    let modalResultSubject = PassthroughSubject<Bool, Never>()

    private let viewModel = ConfirmModalViewModel(text: "text", yesButtonText: "yes", noButtonText: "no")
    private var cancellableBag = Set<AnyCancellable>()

    init() {
        modalResultSubject
            .assign(toSubject: viewModel.resultSubject)
            .store(in: &cancellableBag)
    }

    func createConfirmModalViewModel(text: String) -> ConfirmModalViewModel {
        return viewModel
    }
}
