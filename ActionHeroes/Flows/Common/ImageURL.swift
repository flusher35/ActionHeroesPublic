//
//  ImageURL.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 26/01/2021.
//

import Foundation

struct ImageURL: Hashable {

    // MARK: - Internal computed properties
    var avatarURL: URL? {
        return urlSized(AppGlobal.is3xScale ? .standardLarge : .standardMedium)
    }

    var bigAvatarURL: URL? {
        return urlSized(AppGlobal.is3xScale ? .standardXLarge : .standardLarge)
    }

    var detailsPhotoURL: URL? {
        return urlSized(.fullSize)
    }

    // MARK: - Private stored properties
    private let pathString: String
    private let extensionString: String

    // MARK: - Internal methods
    init?(from actionHeroThumbnail: ActionHeroThumbnail?) {
        guard let actionHeroThumbnail = actionHeroThumbnail else { return nil }
        pathString = actionHeroThumbnail.path
        extensionString = actionHeroThumbnail.extension
    }

    func urlSized(_ size: ImageSize) -> URL? {
        let urlString: String = {
            if size == .fullSize {
                return [pathString, extensionString].joined(separator: ".")
            } else {
                return [[pathString, size.rawValue].joined(separator: "/"), extensionString].joined(separator: ".")
            }
        }()
        return URL(string: urlString)
    }
}
