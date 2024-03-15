//
//  SettingsService.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 12.03.2024.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable {
    case systemDefault = "system"
    case dark = "black"
    case light = "light"
    case glass = "Finex"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .dark:
            return .dark
        case .light:
            return .light
        case .glass:
            return .dark
        }
    }
}

enum Currency: String, CaseIterable, Identifiable{
    case ruble = "₽"
    case dollar = "$"
    case yean = "¥"
    
    var id: Self { self }
}

