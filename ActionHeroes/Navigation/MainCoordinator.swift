//
//  MainCoordinator.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Combine
import UIKit

enum MainCoordinatorRoute: Route {
    case showDetails(ActionHeroItem)
}

class MainCoordinator: BaseCoordinator<MainCoordinatorRoute> {

    // MARK: - Internal methods
    override func start() {
        let viewModel = MainViewModel()
        viewModel.navigation
            .sink { [weak self] in self?.navigate($0) }
            .store(in: &cancellableBag)
        let viewController = CustomHostingController(rootView: MainView(viewModel: viewModel))
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods
    private func navigate(_ route: MainCoordinatorRoute) {
        switch route {
        case .showDetails(let hero): showDetails(hero)
        }
    }

    private func showDetails(_ hero: ActionHeroItem) {
        let viewModel = DetailsViewModel(actionHero: hero)
        let viewController = CustomHostingController(rootView: DetailsView(viewModel: viewModel))
        navigationController.pushViewController(viewController, animated: true)
    }
}
