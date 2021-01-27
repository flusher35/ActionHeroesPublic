//
//  Dictionary+Extension.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 18/01/2021.
//

extension Dictionary {
    func merged(with dict: [Key: Value]) -> Dictionary<Key, Value> {
        var dictionary = self
        for (k, v) in dict {
            dictionary.updateValue(v, forKey: k)
        }
        return dictionary
    }
}
