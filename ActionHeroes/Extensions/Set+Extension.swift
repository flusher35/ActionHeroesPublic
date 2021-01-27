//
//  Set+Extension.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 22/01/2021.
//

extension Set {
    mutating func insert(_ contents: [Element]) {
        var set = self
        contents.forEach { set.insert($0) }
        self = set
    }

    mutating func removeAll(where condition: (Element) -> Bool) {
        self = self.filter { !condition($0) }
    }

    mutating func update(with element: Element?) {
        guard let element = element else { return }
        update(with: element)
    }

    mutating func remove(_ member: Element?) {
        guard let member = member else { return }
        remove(member)
    }
}
