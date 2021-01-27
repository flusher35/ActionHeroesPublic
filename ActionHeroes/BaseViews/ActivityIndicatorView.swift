//
//  ActivityIndicatorView.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 17/01/2021.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {

    private var style: UIActivityIndicatorView.Style

    init(style: UIActivityIndicatorView.Style = .medium) {
        self.style = style
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) { }
}
