//
//  ConfirmModalView.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 23/01/2021.
//

import SwiftUI

struct ConfirmModalView: View {

    @ObservedObject var viewModel: ConfirmModalViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.text)
                .font(.custom(.sfProTextSemibold, size: 18))
                .foregroundColor(.white)
                .lineSpacing(5)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            Button(viewModel.yesButtonText) { viewModel.resultSubject.send(true) }
                .buttonStyle(RedButtonStyle(config: .primary))
            Button(viewModel.noButtonText) { viewModel.resultSubject.send(false) }
                .buttonStyle(RedButtonStyle(config: .secondary))
        }
    }
}
