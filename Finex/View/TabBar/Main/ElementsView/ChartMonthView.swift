//
//  ChartMonthView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 05.02.2024.
//

import SwiftUI
import RealmSwift

struct ChartMonthView: View {
    
    @Binding var selectExpenditure: Int
    @State var costCats: [Int]
    @State var incomeCats: [Int]
    @State var date: Date
    @EnvironmentObject var cost: Cost
    @EnvironmentObject var income: Income
    @ObservedResults(IncomeItem.self) var incomeItems
    @ObservedResults(CostItem.self) var costItems
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        
        let monthDataCost: [(Double, Color)] = charCost(date: date, items: costItems)
        let monthDataIncome: [(Double, Color)] = charIncome(date: date, items: incomeItems)
        
        ZStack{
            Rectangle()
                .frame(height: 300)
                .foregroundColor(userTheme == .glass ? .clear : .picker)
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 80, height: 260)
                .foregroundColor(userTheme == .glass ? .clear : .picker)
                .cornerRadius(20)
                .shadow(color: userTheme == .glass ? .clear : .shadow, radius: 10)
                .glass(cornerRadius: 20)
            if selectExpenditure == 0 {
                withAnimation(.bouncy){
                    Pie(slices: monthDataCost)
                        .frame(width: UIScreen.main.bounds.width - 130)
                }
            } else if selectExpenditure == 1 {
                withAnimation(.bouncy){
                    Pie(slices: monthDataIncome)
                        .frame(width: UIScreen.main.bounds.width - 130)
                }
            }
            Circle()
                .frame(width: UIScreen.main.bounds.width - 180)
                .foregroundColor(userTheme == .glass ? .clear : .picker)
                .glass(cornerRadius: 200)
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
    
    func charCost(date: Date, items: Results<CostItem>) -> [(Double, Color)] {
        var result: [(Double, Color)] = []
        
        for i in 0..<cost.gettCount() {
            result.append((0, Color(cost.categories[i].color)))
        }
        
        for i in 0..<items.count {
            let value = Double(items[i].cost)
            
            if items[i].cat < cost.gettCount() {
                if Int(items[i].textDateMonth!) == Int(nowMonth(date: self.date)) {
                    result[items[i].cat].0 += value
                }
            }
        }
        
        return result
    }
    
    func charIncome(date: Date, items: Results<IncomeItem>) -> [(Double, Color)] {
        var result: [(Double, Color)] = []
        
        for i in 0..<income.getCount() {
            result.append((0, Color(income.categories[i].color)))
        }
        
        for i in 0..<items.count {
            let value = Double(items[i].income)
            
            if items[i].cat < income.getCount() {
                if Int(items[i].textDateMonth!) == Int(nowMonth(date: self.date)) {
                    result[items[i].cat].0 += value
                }
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

struct Pie: View {
    
    @State var slices: [(Double, Color)]
    
    var body: some View {
        Canvas { context, size in
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    ChartMonthView(selectExpenditure: .constant(0), costCats: [], incomeCats: [], date: Date()).environmentObject(Cost()).environmentObject(Income())
}
