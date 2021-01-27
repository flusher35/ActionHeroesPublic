//
//  DetailsViewModel.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 19/01/2021.
//

import Combine
import UIKit

class DetailsViewModel: BaseViewModel, ObservableObject {

    // MARK: - Internal stored properties
    let recruitButtonSubject = PassthroughSubject<Void, Never>()
    @Published var recruitButtonTitle = ""
    @Published var recruitButtonStyle = RedButtonStyleConfig.primary
    @Published var actionHero: ActionHeroItem
    @Published var isModalPresented = false
    var modalType: DetailsViewModalType?

    // MARK: - Private stored properties
    private let hiringManager: ActionHeroHiringProviding
    private let modalFactory: DetailsViewModelModalFactoryProviding

    // MARK: - Internal methods
    init(actionHero: ActionHeroItem,
         hiringManager: ActionHeroHiringProviding = AppSettings.shared,
         modalFactory: DetailsViewModelModalFactoryProviding = DetailsViewModelModalFactory()) {
        self.actionHero = actionHero
        self.hiringManager = hiringManager
        self.modalFactory = modalFactory
        super.init()
        setupBindings()
    }

    deinit {
        recruitButtonSubject.send(completion: .finished)
    }

    // MARK: - Private methods
    private func setupBindings() {
        hiringManager.hiredHeroesIDsPublisher
            .combineLatest(Just(actionHero))
            .map { $0.0.contains($0.1.id) ? Strings.fireFromSquad : Strings.recruitToSquad }
            .assignNoRetain(to: \.recruitButtonTitle, on: self)
            .store(in: &cancellableBag)

        hiringManager.hiredHeroesIDsPublisher
            .combineLatest(Just(actionHero))
            .map { $0.0.contains($0.1.id) ? RedButtonStyleConfig.secondary : RedButtonStyleConfig.primary }
            .assignNoRetain(to: \.recruitButtonStyle, on: self)
            .store(in: &cancellableBag)

        recruitButtonSubject
            .withLatestFrom(hiringManager.hiredHeroesIDsPublisher, Just(actionHero))
            .map { (isHired: $0.0.contains($0.1.id), hero: $0.1) }
            .sink { [weak self] in
                if $0.isHired {
                    self?.showConfirmModal()
                } else {
                    self?.hiringManager.hiredHeroesModifyIDsSubject.send(.add($0.hero.id))
                }
            }
            .store(in: &cancellableBag)
    }

    private func showConfirmModal() {
        let viewModel = modalFactory.createConfirmModalViewModel(text: Strings.areYouSureFireHero.addArgument(actionHero.name ?? Strings.hero))
        viewModel.resultSubject
            .filter { $0 }
            .combineLatest(Just(actionHero))
            .map { ArrayItemModifier.remove($0.1.id) }
            .assign(toSubject: hiringManager.hiredHeroesModifyIDsSubject)
            .store(in: &cancellableBag)
        viewModel.resultSubject
            .map { _ in false }
            .assignNoRetain(to: \.isModalPresented, on: self)
            .store(in: &cancellableBag)
        modalType = .confirm(viewModel)
        isModalPresented = true
    }
}
