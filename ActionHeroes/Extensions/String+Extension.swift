//
//  String+Extension.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 23/01/2021.
//

extension String {
    func addArgument(_ arg: Any) -> String {
        return String(format: self, arguments: [String(describing: arg)])
    }
}
