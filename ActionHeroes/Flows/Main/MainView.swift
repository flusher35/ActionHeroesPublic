//
//  MainView.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 16/01/2021.
//

import Kingfisher
import SwiftUI

struct MainView: View {

    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 6) {
                header
                mainList
            }
            .padding(.top, 6)
            errorView
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Image(ImageName.marvelLogo)
            Rectangle()
                .foregroundColor(Color.white.opacity(0.15))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
        }
    }

    @ViewBuilder private var hiredHeroesView: some View {
        if viewModel.isSquadSectionVisible {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(Strings.mySquad)
                        .foregroundColor(.white)
                        .font(.custom(.sfProDisplaySemibold, size: 20))
                    if viewModel.isSquadListLoading {
                        activityIndicatorView(style: .white, maxWidth: false)
                    }
                }
                horizontalList
            }
            .padding(.horizontal, 16)
        }
    }

    private var mainList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 16) {
                hiredHeroesView
                ForEach(viewModel.actionHeroItems) { item in
                    listItem(item)
                }
                if viewModel.isMainListLoading {
                    activityIndicatorView(style: .whiteLarge)
                }
            }
        }
    }

    private var horizontalList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 8) {
                ForEach(viewModel.hiredHeroesItems) { item in
                    horizontalListItem(item)
                }
            }
        }
        .frame(height: 104)
    }

    private func horizontalListItem(_ item: ActionHeroItem) -> some View {
        VStack(spacing: 4) {
            KFImage(item.imageURL?.bigAvatarURL)
                .placeholder { Color.white.opacity(0.05) }
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            if let name = item.name {
                Text(name)
                    .foregroundColor(.white)
            }
        }
        .font(.custom(.sfProTextSemibold, size: 13))
        .lineLimit(2)
        .multilineTextAlignment(.center)
        .frame(width: 64)
        .onTapGesture { viewModel.itemTapped(item) }
    }

    private func listItem(_ item: ActionHeroItem) -> some View {
        HStack(spacing: 0) {
            KFImage(item.imageURL?.avatarURL)
                .placeholder { Color.white.opacity(0.05) }
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .padding(.trailing, 16)
            if let name = item.name {
                Text(name)
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: ImageName.chevronRight)
                .renderingMode(.template)
                .foregroundColor(Color.white.opacity(0.25))
        }
        .font(.custom(.sfProTextSemibold, size: 17))
        .lineLimit(1)
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color.cellBackground)
        .cornerRadius(8)
        .padding(.horizontal)
        .onAppear { viewModel.itemAppeared(item) }
        .onTapGesture { viewModel.itemTapped(item) }
    }

    private func activityIndicatorView(style: UIActivityIndicatorView.Style, maxWidth: Bool = true) -> some View {
        ActivityIndicatorView(style: style)
            .frame(maxWidth: maxWidth ? .infinity : nil)
    }

    @ViewBuilder private var errorView: some View {
        if let message = viewModel.errorMessage {
            Text(message)
                .foregroundColor(.white)
                .font(.custom(.sfProTextSemibold, size: 16))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(8)
                .padding()
                .animation(.default)
        }
    }
}
