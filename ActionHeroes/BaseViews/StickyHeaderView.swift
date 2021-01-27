//
//  StickyHeaderView.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 22/01/2021.
//

import SwiftUI

struct StickyHeader<Content: View>: View {
    private let minHeight: CGFloat
    private let content: Content

    init(minHeight: CGFloat = 200, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.content = content()
    }

    var body: some View {
        GeometryReader { geo in
            if geo.frame(in: .global).minY <= 0 {
                content
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            } else {
                content
                    .offset(y: -geo.frame(in: .global).minY)
                    .frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
            }
        }
        .frame(minHeight: minHeight)
    }
}
