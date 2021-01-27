//
//  View+Extension.swift
//  ActionHeroes
//
//  Created by Anton Shevtsov on 23/01/2021.
//

import SwiftUI

extension View {
    public func modal<ModalContent: View>(isPresented: Binding<Bool>,
                                          canDismiss: Bool = true,
                                          content: () -> ModalContent) -> some View {
        ModalView(isPresented: isPresented,
                    parent: self,
                    canDismiss: canDismiss,
                    content: content)
    }
}
