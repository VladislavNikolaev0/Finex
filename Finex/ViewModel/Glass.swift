//
//  Glass.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 09.03.2024.
//

import Foundation
import SwiftUI

struct Glass: ViewModifier {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    private var cornerRadius: CGFloat
    private var gradientColors: [Color] {
        [
            Color.white,
            Color.white.opacity(0.1),
            Color.white.opacity(0.1),
            Color.white.opacity(0.4),
            Color.white.opacity(0.5)
        ]
    }
    
    init(_ cornerRadius: CGFloat = 16) {
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        if userTheme == .glass {
            content
                .background{
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Material.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                }
                .overlay{
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                }
        } else {
            content
        }
    }
}

//extension View {
//    
//    func glass(cornerRadius: CGFloat = 16) -> some View {
//        modifier(Glass(cornerRadius))
//    }
//    
//}
