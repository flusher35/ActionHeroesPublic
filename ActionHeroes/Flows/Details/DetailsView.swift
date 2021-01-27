//
//  DetailsView.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 19/01/2021.
//

import Kingfisher
import SwiftUI

struct DetailsView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DetailsViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.background.edgesIgnoringSafeArea(.all)
            content
            header
        }
        .modal(isPresented: $viewModel.isModalPresented) { modalView }
    }

    private var header: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) { Image(ImageName.backButton) }
            .buttonStyle(PressButtonStyle())
            .padding(16)
    }

    private var imageView: some View {
        KFImage(viewModel.actionHero.imageURL?.detailsPhotoURL)
            .setProcessor(ResizingImageProcessor(referenceSize: CGSize(width: 320, height: 320), mode: ContentMode.none))
            .placeholder { ActivityIndicatorView(style: .whiteLarge) }
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }

    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            StickyHeader(minHeight: 320) {
                imageView
            }
            VStack(alignment: .leading, spacing: 20) {
                if let name = viewModel.actionHero.name {
                    Text(name)
                        .font(.custom(.sfProDisplayBold, size: 34))
                }
                recruitButton
                if let description = viewModel.actionHero.description {
                    Text(description)
                        .font(.custom(.sfProTextRegular, size: 17))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 42)
            .padding(.bottom, 32)
            .lineSpacing(5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
        }
    }

    private var recruitButton: some View {
        Button(viewModel.recruitButtonTitle) { viewModel.recruitButtonSubject.send() }
            .buttonStyle(RedButtonStyle(config: viewModel.recruitButtonStyle))
    }

    @ViewBuilder private var modalView: some View {
        if viewModel.isModalPresented {
            switch viewModel.modalType {
            case .confirm(let viewModel): ConfirmModalView(viewModel: viewModel)
            default: EmptyView()
            }
        }
    }
}
