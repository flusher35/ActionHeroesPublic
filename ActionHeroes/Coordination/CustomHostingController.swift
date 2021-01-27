//
//  CustomHostingController.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

import SwiftUI

class CustomHostingController<T: View>: UIHostingController<T> {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
