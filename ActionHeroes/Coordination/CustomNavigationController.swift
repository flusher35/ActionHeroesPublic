//
//  CustomNavigationController.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 25/01/2021.
//

import UIKit

final class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension CustomNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
        return viewControllers.count > 1
    }
}
