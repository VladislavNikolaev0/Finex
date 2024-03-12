//
//  BudgetItemView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 04.02.2024.
//

import SwiftUI

struct BudgetItemView: View {
    
    @Binding var showingBudget: Bool
    @EnvironmentObject var budget: Budget
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("currency") private var currency: Currency = .ruble
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    var costCats: [Int]
    var timeInterval: Int
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack{
                Rectangle()
                    .frame(height: 180)
                    .foregroundColor(userTheme == .glass ? .clear : .picker)
                Rectangle()
                    .frame(width: 335, height: 150)
                    .foregroundColor(userTheme == .glass ? .clear : .picker)
                    .cornerRadius(20)
                    .shadow(color: userTheme == .glass ? .shadow.opacity(0) : .shadow.opacity(0.7), radius: 10)
                    .glass(cornerRadius: 20)
                VStack(alignment: .leading, spacing: 6) {
                    Button(action: {
                        self.showingBudget.toggle()
                    }){
                        HStack{
                            Image(systemName: "rublesign.circle.fill")
                                .foregroundColor(Color("paleGreen"))
                            Text("budget".localized(language.rawValue))
                                .foregroundColor(Color("paleGreen"))
                            Spacer().frame(width: 200)
                            Image(systemName: "arrowtriangle.right")
                                .foregroundColor(Color("paleGreen"))
                        }
                    }.sheet(isPresented: $showingBudget, content: {
                        BudgetView()
                            .presentationDetents([.height(200)])
                    })
                    if timeInterval == 360 {
                        Text("lost".localized(language.rawValue))
                        Divider()
                            .frame(width: 310, height: 1)
                            .foregroundColor(Color("paleGreen"))
                        Text("\(costCats.reduce(0) { $0 + $1 }) \(currency.rawValue)")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                    } else {
                        Text("\(costCats.reduce(0) { $0 + $1 } > budget.getBudget() / timeInterval ? "over".localized(language.rawValue) : "notOver".localized(language.rawValue))")
                        Divider()
                            .frame(width: 310, height: 1)
                            .foregroundColor(Color("paleGreen"))
                        Text("\(costCats.reduce(0) { $0 + $1 }) \(currency.rawValue) / \(budget.getBudget() / timeInterval) \(currency.rawValue)")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                    }
                }
            }
        }
    }
}

struct BudgetItemView_Previews: PreviewProvider {
    static var budget = Budget()
    
    static var previews: some View {
        BudgetItemView(showingBudget: .constant(false), costCats: [0, 0, 0, 0, 0, 0], timeInterval: 31).environmentObject(budget)
    }
}
