//
//  BaseCoordinator.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import Combine
import UIKit

class BaseCoordinator<RouteType: Route>: NSObject, Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var cancellableBag = Set<AnyCancellable>()

    // MARK: - Internal methods
    func start() {}

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        hideNavigationBarBackgroundAndShadow()
    }

    // MARK: - Private methods
    private func hideNavigationBarBackgroundAndShadow() {
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
