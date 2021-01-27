//
//  Coordinator.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}
