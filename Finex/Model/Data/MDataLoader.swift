//
//  DataLoader.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 04.01.2024.
//

import Foundation
import SwiftUI
import RealmSwift

class IncomeItem: Object, ObjectKeyIdentifiable{
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var cat: Int
    @Persisted var income: Int
    @Persisted var date: Date
    
    var textDate: String? {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = String(calendar.component(.year, from: date))
        let textYear = year.suffix(from: year.index(year.startIndex, offsetBy: 2))
        
        return "\(day).\(month).\(textYear)"
    }
    
    var textDateDay: String? {
            let calendar = Calendar.current
            let weekDay = calendar.component(.weekday, from: date)
    
            return "\(weekDay)"
        }
    
    var textDateWeek: String? {
        let calendar = Calendar.current
        let nowWeek = calendar.component(.weekOfMonth, from: date)
        
        return "\(nowWeek)"
    }
    
    var textDateWeekInYear: String? {
        let calendar = Calendar.current
        let week = calendar.component(.weekOfYear, from: date)
        
        return "\(week)"
    }
    
    var textDateMonth: String? {
        let calendar = Calendar.current
        let nowMonth = calendar.component(.month, from: date)
        
        return "\(nowMonth)"
    }
    
    var textDateYear: String? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        return "\(year)"
    }
       
    override class func primaryKey() -> String? {
        "id"
    }
}

struct CategoryIncome: Codable {
    var icon: String
    var color: String
    var title: String
}

class CostItem: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var cat: Int
    @Persisted var cost: Int
    @Persisted var date: Date
    
    var textDate: String? {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = String(calendar.component(.year, from: date))
        let textYear = year.suffix(from: year.index(year.startIndex, offsetBy: 2))
        
        return "\(day).\(month).\(textYear)"
    }
    
    var textCost: String {
        return String(cost) + "P"
    }
    
    var textCat: String? {
        return String(cat)
    }
    
    var textDateDay: String? {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: date)
        
        return "\(weekDay)"
    }
    
    var textDateWeek: String? {
        let calendar = Calendar.current
        let nowWeek = calendar.component(.weekOfMonth, from: date)
        
        return "\(nowWeek)"
    }
    
    var textDateWeekInYear: String? {
        let calendar = Calendar.current
        let week = calendar.component(.weekOfYear, from: date)
        
        return "\(week)"
    }
    
    var textDateMonth: String? {
        let calendar = Calendar.current
        let nowMonth = calendar.component(.month, from: date)
        
        return "\(nowMonth)"
    }
    
    var textDateYear: String? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        return "\(year)"
    }
    
}

struct CategoryCost: Codable {
    var icon: String
    var color: String
    var title: String
}


struct BudgetItem: Identifiable, Codable{
    var id = UUID()
    let budget: Int
}

