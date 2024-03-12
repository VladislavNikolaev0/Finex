//
//  HistoryView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 06.01.2024.
//

import SwiftUI
import RealmSwift

struct HistoryView: View {
    
    private let tabBarNames = ["waste", "income"]
    @State private var selectTabBar = 0
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        ZStack(alignment: .top){
            if selectTabBar == 0 {
                CostHistoryView().environmentObject(Cost())
            } else {
                IncomeHistoryView().environmentObject(Income())
            }
            
            HStack{
                ForEach(0..<2){ number in
                    Spacer()
                    Button(action:{
                        self.selectTabBar = number
                    }){
                        Text(tabBarNames[number].localized(language.rawValue))
                            .foregroundColor(.paleGreen)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .glass(cornerRadius: 20)
                            
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}

