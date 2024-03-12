//
//  Categories.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 30.01.2024.
//

import SwiftUI
import RealmSwift

struct Categories: View {
    
    var selectExpenditure: Int
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    var costCats: [Int]
    var incomeCats: [Int]
    var date: Date
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("currency") private var currency: Currency = .ruble
    
    var body: some View {
        VStack{
            if (selectExpenditure == 0) {
                ForEach(0..<cost.gettCount(), id: \.self) { number in
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(cost.categories[number].color))
                                .cornerRadius(10)
                            Image(systemName: cost.categories[number].icon)
                                .foregroundColor(.picker)
                        }
                        Text(cost.categories[number].title.localized(language.rawValue))
                        Spacer(minLength: 0)
                        Text("\(costCats[number]) \(currency.rawValue)")
                            
                    }
                    Divider()
                }
            } else {
                
                ForEach(0..<income.getCount(), id: \.self) { number in
                    HStack{
                        ZStack{
                            Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(income.categories[number].color))
                                .cornerRadius(10)
                            Image(systemName: income.categories[number].icon)
                                .foregroundColor(.picker)
                        }
                        Text(income.categories[number].title.localized(language.rawValue))
                        Spacer(minLength: 0)
                        Text("\(incomeCats[number]) \(currency.rawValue)")
                    }
                    Divider()
                }
            }
        }
        .padding(13)
        .glass(cornerRadius: 10)
    }
    
    func getDataCost(date: Date, items: [CostItem]) -> [Int] {

        var result = Array(repeating: 0, count: cost.gettCount())

        items.filter { Int($0.textDateDay!) == Int(nowDay(date: self.date)) }
             .forEach { elem in
                 if elem.cat < cost.gettCount() {
                     result[elem.cat] += elem.cost
                 }
             }

        return result
    }
    
    func getDataIncome(data: Date, items: [IncomeItem]) -> [Int] {
        var result = Array(repeating: 0, count: income.getCount())
        
        items.filter { Int($0.textDateDay!) == Int(nowDay(date: self.date)) }
            .forEach { elem in
                if elem.cat < income.getCount() {
                    result[elem.cat] += elem.income
                }
            }
        
        return result
    }
    
    func nowDay(date: Date) -> String {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: date)
        
        return "\(weekDay)"
    }
}

struct Categories_Prewiews: PreviewProvider{
    static let cost = Cost()
    static let income = Income()
    
    static var previews: some View{
        Categories(selectExpenditure: 1, costCats: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], incomeCats: [0 ,0 ,0, 0, 0, 0], date: Date()).environmentObject(cost).environmentObject(income)
    }
}
