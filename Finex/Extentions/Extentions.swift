//
//  Extentions.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 12.03.2024.
//

import Foundation
import SwiftUI

extension String {
    
    func localized(_ lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension View {
    
    func glass(cornerRadius: CGFloat = 16) -> some View {
        modifier(Glass(cornerRadius))
    }
    
    func screenSize() -> CGSize{
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        return window.screen.bounds.size
    }
}


extension HStack {
    func themeRowBackground(theme: Theme) -> some View {
        listRowBackground(theme == .glass ? Rectangle().opacity(0).glass(cornerRadius: 10) : nil)
    }
}
