//
//  MonthView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 06.01.2024.
//

import SwiftUI
import RealmSwift

struct MonthView: View {
    
    @State private var selectExpenditure = 0
    @State private var showingBudget = false
    @State private var date = Date()
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    @EnvironmentObject var budget: Budget
    @ObservedResults(IncomeItem.self) var incomeItems
    @ObservedResults(CostItem.self) var costItems
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        
        let costCats: [Int] = getDataCost(date: date, items: costItems)
        let incomeCats: [Int] = getDataIncome(data: date, items: incomeItems)
        
        ScrollView{
            VStack{
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Spacer()
                        Button(action:{
                            self.showingBudget.toggle()
                        }) {
                            Text("budget".localized(language.rawValue))
                                .foregroundColor(.paleGreen)
                        }.sheet(isPresented: $showingBudget, content: {
                            BudgetView()
                                .presentationDetents([.height(200)])
                        })
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    ButtonsLostGetView(selectExpenditure: $selectExpenditure, costCats: costCats, incomeCats: incomeCats)
                    
                }.padding(.horizontal)
                
                ChartMonthView(selectExpenditure: $selectExpenditure, costCats: costCats, incomeCats: incomeCats, date: date)
                    .environmentObject(income)
                    .environmentObject(cost)
                
                Text("categories".localized(language.rawValue))
                
                Categories(selectExpenditure: selectExpenditure, costCats: costCats, incomeCats: incomeCats, date: date)
                    .environmentObject(income)
                    .environmentObject(cost)
                    .padding(.horizontal)

                VStack(alignment: .center) {
                    BudgetItemView(showingBudget: $showingBudget, budget: _budget, costCats: costCats, timeInterval: 1)
                }
            }
            .padding(.top, 80)
            .padding(.bottom, 70)
        }
        .background{
            if userTheme == .glass {
                Image("finexBg")
                    .resizable()
                    .ignoresSafeArea()
            }
        }
    }
    
    func getDataCost(date: Date, items: Results<CostItem>) -> [Int] {
        var result = Array(repeating: 0, count: cost.gettCount())

        items.filter { Int($0.textDateMonth!) == Int(nowMonth(date: self.date)) }
             .forEach { elem in
                 if elem.cat < cost.gettCount() {
                     result[elem.cat] += Int(elem.cost)
                 }
             }

        return result
    }
    
    func getDataIncome(data: Date, items: Results<IncomeItem>) -> [Int] {
        var result = Array(repeating: 0, count: income.getCount())
        
        items.filter { Int($0.textDateMonth!) == Int(nowMonth(date: self.date)) }
            .forEach { elem in
                if elem.cat < income.getCount() {
                    result[elem.cat] += Int(elem.income)
                }
            }
        
        return result
    }
    
    func nowMonth(date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        return "\(month)"
    }
}

struct MonthView_Previews: PreviewProvider {
    static let income = Income()
    static let cost = Cost()
    static let budget = Budget()
    
    static var previews: some View {
        MonthView().environmentObject(income).environmentObject(cost).environmentObject(budget)
    }
}
