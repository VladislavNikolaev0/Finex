//
//  CostHistoryView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 08.02.2024.
//

import SwiftUI
import RealmSwift

struct CostHistoryView: View {
    
    @EnvironmentObject var cost: Cost
    @ObservedResults(CostItem.self) var costItems
    @AppStorage("currency") private var currency: Currency = .ruble
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        List{
            ForEach(costItems.reversed()){item in
                if item.cat < cost.gettCount() {
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(userTheme == .glass ? .bg.opacity(0) : .picker)
                                .cornerRadius(10)
                            Image(systemName: cost.categories[item.cat].icon)
                                .foregroundColor(Color(cost.categories[item.cat].color))
                        }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(cost.categories[item.cat].color),lineWidth: 2))
                        Text("")
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(item.textDate!)")
                                .foregroundColor(userTheme == .glass ? .white : Color("bg"))
                            Text("\(item.cost) \(currency.rawValue)")
                        }
                    }.themeRowBackground(theme: userTheme)
                }
            }.onDelete { indices in
                indices.forEach { index in
                    let itemToDelete = Array(costItems.reversed())[index]
                    $costItems.remove(itemToDelete)
                }
            }
        }
        .padding(.bottom, 70)
        .scrollContentBackground(userTheme == .glass ? .hidden : .visible)
        .background{
            if userTheme == .glass {
                Image("finexBg")
                    .resizable()
                    .ignoresSafeArea()
                    .frame(height: UIScreen.main.bounds.height - 20)
            }
        }
    }
}

#Preview {
    CostHistoryView().environmentObject(Cost())
}
