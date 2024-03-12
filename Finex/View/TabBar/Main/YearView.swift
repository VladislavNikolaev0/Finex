//
//  YearView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 06.01.2024.
//

import SwiftUI
import Charts
import RealmSwift

struct YearView: View {
    
    @State var selectExpenditure = 0
    @State var showingBudget = false
    @State var date = Date()
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    @EnvironmentObject var budget: Budget
    let yeardays = ["ja", "fe", "ma", "ap", "may", "jun", "jul", "au", "sept", "oct", "no", "de"]
    @ObservedResults(IncomeItem.self) var incomeItems
    @ObservedResults(CostItem.self) var costItems
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        
        let costCats: [Int] = getDataCost(date: date, items: costItems)
        let incomeCats: [Int] = getDataIncome(data: date, items: incomeItems)
        let valuesCost: [Int] = charCostYear(date: date, items: costItems)
        let valuesIncome: [Int] = charIncomeYear(date: date, items: incomeItems)
        
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
                ZStack{
                    Rectangle()
                        .frame(height: 220)
                        .foregroundColor(userTheme == .glass ? .clear : .picker)
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 30, height: 180)
                        .foregroundColor(userTheme == .glass ? .clear : .picker)
                        .cornerRadius(20)
                        .shadow(color: userTheme == .glass ? .clear : .shadow, radius: 10)
                        .glass(cornerRadius: 20)
                    Chart {
                        ForEach (0..<Int(nowMonth(date: date))!, id: \.self) { index in
                            LineMark(
                                x: .value("Day", yeardays[index].localized(language.rawValue)),
                                y: .value("Value", selectExpenditure == 0 ? valuesCost[index] : valuesIncome[index])
                            )
                            .foregroundStyle(Color("paleGreen"))
                            .cornerRadius(5)
                        }
                    }.frame(width: UIScreen.main.bounds.width - 50, height: 150)
                }
                Text("categories".localized(language.rawValue))
                
                Categories(selectExpenditure: selectExpenditure, costCats: costCats, incomeCats: incomeCats, date: date)
                    .environmentObject(income)
                    .environmentObject(cost)
                    .padding(.horizontal)
                
                BudgetItemView(showingBudget: $showingBudget, budget: _budget, costCats: costCats, timeInterval: 360)
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
    
    func charCostYear(date: Date, items: Results<CostItem>) -> [Int] {
        var result = Array(repeating: 0, count: 12)
        items.filter { Int($0.textDateYear!) == Int(nowYear(date: self.date)) }
            .forEach { elem in
                result[Int(elem.textDateMonth!)! - 1] += Int(elem.cost)
            }
        return result
    }
    
    func charIncomeYear(date: Date, items: Results<IncomeItem>) -> [Int] {
        var result = Array(repeating: 0, count: 12)
        
        items.filter { Int($0.textDateYear!) == Int(nowYear(date: self.date)) }
            .forEach { elem in
                result[Int(elem.textDateMonth!)! - 1] += Int(elem.income)
            }

        return result
    }
    
    func getDataCost(date: Date, items: Results<CostItem>) -> [Int] {
        var result = Array(repeating: 0, count: cost.gettCount())

        items.filter { Int($0.textDateYear!) == Int(nowYear(date: self.date)) }
             .forEach { elem in
                 if elem.cat < cost.gettCount() {
                     result[elem.cat] += Int(elem.cost)
                 }
             }

        return result
    }
    
    func getDataIncome(data: Date, items: Results<IncomeItem>) -> [Int] {
        var result = Array(repeating: 0, count: income.getCount())
        
        items.filter { Int($0.textDateYear!) == Int(nowYear(date: self.date)) }
            .forEach { elem in
                if elem.cat < income.getCount() {
                    result[elem.cat] += Int(elem.income)
                }
            }
        
        return result
    }
    
    func nowYear(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        return "\(year)"
    }
    
    func nowMonth(date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        return "\(month)"
    }
}

struct YearView_Previews: PreviewProvider {
    static let income = Income()
    static let cost = Cost()
    static let budget = Budget()
    
    static var previews: some View {
        YearView().environmentObject(income).environmentObject(cost).environmentObject(budget)
    }
}
