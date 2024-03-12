//
//  WeekView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 06.01.2024.
//

import SwiftUI
import Charts
import RealmSwift

struct WeekView: View {
    
    @State var selectExpenditure = 0
    @State var showingBudget = false
    @State var date = Date()
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    @EnvironmentObject var budget: Budget
    @ObservedResults(IncomeItem.self) var incomeItems
    @ObservedResults(CostItem.self) var costItems
    let weekdays = ["su", "mo", "tu", "we", "th", "fr", "sa"]
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    
    var body: some View {
        
        let costCats: [Int] = getDataCost(date: date, items: costItems)
        let incomeCats: [Int] = getDataIncome(data: date, items: incomeItems)
        let valuesCost: [Int] = charCostWeek(date: date, items: costItems)
        let valuesIncome: [Int] = charIncomeWeek(date: date, items: incomeItems)
        
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
                        ForEach (weekdays.indices, id: \.self) { index in
                            BarMark(
                                x: .value("Day", weekdays[index].localized(language.rawValue)),
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

                var numbersWeeks: Int {
                    let calendar = Calendar.current
                    let weeksRange = calendar.range(of: .weekOfMonth, in: .month, for: date)!
                    let numbers = weeksRange.count
                    
                    return numbers
                }
                
                BudgetItemView(showingBudget: $showingBudget, costCats: costCats, timeInterval: numbersWeeks)

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
//    def binary_search(arr, target):
//        low = 0
//        high = len(arr) - 1
//        while low <= high:
//            mid = (low + high) // 2
//            guess = arr[mid]
//            if guess == target:
//                return mid
//            if guess > target:
//                high = mid - 1
//            else:
//                low = mid + 1
    
    func charCostWeek(date: Date, items: Results<CostItem>) -> [Int] {
        var result = Array(repeating: 0, count: 7)
        items.filter { Int($0.textDateWeekInYear!) == Int(nowWeekInYear(date: self.date)) }
            .forEach { elem in
                result[Int(elem.textDateDay!)! - 1] += Int(elem.cost)
            }
        
        return result
    }
    
    func charIncomeWeek(date: Date, items: Results<IncomeItem>) -> [Int] {
        var result = Array(repeating: 0, count: 7)
        
        items.filter { Int($0.textDateWeekInYear!) == Int(nowWeekInYear(date: self.date)) }
            .forEach { elem in
                result[Int(elem.textDateDay!)! - 1] += Int(elem.income)
            }
        
        return result
    }
    
    func getDataCost(date: Date, items: Results<CostItem>) -> [Int] {
        var result = Array(repeating: 0, count: cost.gettCount())

        items.filter { Int($0.textDateWeek!) == Int(nowWeek(date: self.date)) }
             .forEach { elem in
                 if elem.cat < cost.gettCount() {
                     result[elem.cat] += Int(elem.cost)
                 }
             }

        return result
    }
    
    func getDataIncome(data: Date, items: Results<IncomeItem>) -> [Int] {
        var result = Array(repeating: 0, count: income.getCount())
        
        items.filter { Int($0.textDateWeek!) == Int(nowWeek(date: self.date)) }
            .forEach { elem in
                if elem.cat < income.getCount() {
                    result[elem.cat] += Int(elem.income)
                }
            }
        
        return result
    }
    
    func nowWeek(date: Date) -> String {
        let calendar = Calendar.current
        let week = calendar.component(.weekOfMonth, from: date)
        
        return "\(week)"
    }
    
    func nowWeekInYear(date: Date) -> String {
        let calendar = Calendar.current
        let week = calendar.component(.weekOfYear, from: date)
        
        return "\(week)"
    }
}

struct WeekView_Previews: PreviewProvider {
    static let income = Income()
    static let cost = Cost()
    static let budget = Budget()
    
    static var previews: some View {
        WeekView().environmentObject(income).environmentObject(cost).environmentObject(budget)
    }
}
