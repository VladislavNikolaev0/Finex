//
//  IncomeHistoryView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 08.02.2024.
//

import SwiftUI
import RealmSwift

struct IncomeHistoryView: View {
    
    @EnvironmentObject var income: Income
    @ObservedResults(IncomeItem.self) var incomeItems
    @AppStorage("currency") private var currency: Currency = .ruble
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        List{
            ForEach(incomeItems.reversed()){ item in
                if item.cat < income.getCount() {
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(userTheme == .glass ? .bg.opacity(0) : .picker)
                                .cornerRadius(10)
                            Image(systemName: income.categories[item.cat].icon)
                                .foregroundColor(Color(income.categories[item.cat].color))
                        }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(income.categories[item.cat].color),lineWidth: 2))
                        Text("")
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(item.textDate!)")
                                .foregroundColor(userTheme == .glass ? .white : Color("bg"))
                            Text("\(item.income) \(currency.rawValue)")
                        }
                    }.themeRowBackground(theme: userTheme)
                }
            }.onDelete { indices in
                indices.forEach { index in
                    let itemToDelete = Array(incomeItems.reversed())[index]
                    $incomeItems.remove(itemToDelete)
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
    IncomeHistoryView().environmentObject(Income())
}
