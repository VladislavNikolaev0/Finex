//
//  KeyboardAdaptive.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 01.03.2024.
//

import Foundation
import SwiftUI

struct KeyboardAdaptive: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                    self.offset = keyboardSize.height - 70
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    self.offset = 0
                }
            }
            .edgesIgnoringSafeArea(.bottom)
    }
}
