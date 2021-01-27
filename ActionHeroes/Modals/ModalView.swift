//
//  ModalView.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 23/01/2021.
//

import SwiftUI

struct ModalView<Parent: View, Content: View>: View {

    // MARK: - Private stored properties
    private let content: Content
    private let parent: Parent
    private let canDismiss: Bool
    @Binding private var isPresented: Bool

    // MARK: - Internal methods
    init(isPresented: Binding<Bool>,
                parent: Parent,
                canDismiss: Bool,
                @ViewBuilder content: () -> Content) {
        self.parent = parent
        self.content = content()
        self.canDismiss = canDismiss
        self._isPresented = isPresented
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                parent
                    .animation(nil)
                    .blur(radius: isPresented ? 16 : 0)
                    .animation(.easeIn)
                    .background(Color.background.edgesIgnoringSafeArea(.all))
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(isPresented ? Color.black.opacity(0.5) : Color.clear)
                    .onTapGesture { canDismiss ? isPresented = false : () }
                    .animation(.easeInOut)
                if isPresented {
                    content
                        .frame(maxHeight: proxy.size.height - proxy.safeAreaInsets.bottom)
                        .zIndex(1000)
                        .padding(16)
                        .padding(.top, 16)
                        .background(Color.background)
                        .cornerRadius(8)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .shadow(color: Color.buttonColor.opacity(0.25), radius: 16, x: 0, y: 6)
                        .transition(AnyTransition.scaleOpacityFromTheBottom.animation(Animation.easeInOut(duration: 0.3)))
                        .transition(AnyTransition.scale)
                }
            }
        }
    }
}

private extension AnyTransition {
    static let scaleOpacityFromTheBottom = AnyTransition.scale(scale: 0.0, anchor: .bottom).combined(with: .opacity)
}
