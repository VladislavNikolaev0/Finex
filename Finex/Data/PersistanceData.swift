//
//  PersistanceData.swift
//  Finex
//
//  Created by Ангел предохранитель on 06.01.2024.
//

//import Foundation
//import RealmSwift
//import SwiftUI
//
//
//class IncomeItemRealm: Object {
//    @objc dynamic var key: Int = 0
//    @objc dynamic var income: Int = 0
//    @objc dynamic var cat: Int = 0
//    @objc dynamic var date: Date = Date()
//    
//    convenience init(key: Int, income: Int, cat: Int, date: Date) {
//        self.init()
//        self.key = key
//        self.income = income
//        self.cat = cat
//        self.date = date
//    }
//}
//
//class CostItemRealm: Object {
//    @objc dynamic var key: Int = 0
//    @objc dynamic var cost: Int = 0
//    @objc dynamic var cat: Int = 0
//    @objc dynamic var date: Date = Date()
//    
//    convenience init(key: Int, cost: Int, cat: Int, date: Date) {
//        self.init()
//        self.key = key
//        self.cost = cost
//        self.cat = cat
//        self.date = date
//    }
//}

//class PersistanceData {
//    static let shared = PersistanceData()
//    
//    private let realm = try! Realm()
//    
//    func addIncome(item: IncomeItemRealm) {
//        let oldData = realm.objects(IncomeItemRealm.self).filter("key = \(item.key)")
//        if oldData.count > 0 { return }
//        try! realm.write {
//            realm.add(item)
//        }
//    }
//    
//    func loadAllIncomes() -> [IncomeItemRealm] {
//        let data = realm.objects(IncomeItemRealm.self)
//        var result: [IncomeItemRealm] = []
//        for item in data {
//            result.append(item)
//        }
//        return result
//    }
//    
////    func loadDayIncomes(date: Date) -> [Int] {
////        var dateWeekDay: String {
////            let calendar = Calendar.current
////            let weekDay = calendar.component(.weekday, from: date)
////            
////            return "\(weekDay)"
////        }
////        var itemsDay: [Int] = [0, 0, 0, 0, 0, 0, 0]
////        var cat: Int = 0
////        let data = realm.objects(IncomeItemRealm.self)
////        
////        ForEach(0..<data.count){ number in
////            var dateIncome: String {
////                return self.getWeekDayIncome(iir: data[number])
////            }
////            if dateWeekDay == dateIncome{
////                itemsDay[data[number].cat] += data[number].income
////            }
////        }
////    }
//    
//    func addCost(item: CostItemRealm) {
//        let oldData = realm.objects(CostItemRealm.self).filter("key = \(item.key)")
//        if oldData.count > 0 { return }
//        try! realm.write { realm.add(item) }
//    }
//    
//    func loadAllCosts() -> [CostItemRealm] {
//        let data = realm.objects(CostItemRealm.self)
//        var result: [CostItemRealm] = []
//        for item in data {
//            result.append(item)
//        }
//        return result
//    }
//    
//    func getWeekDayIncome(iir: IncomeItemRealm) -> String {
//        var dateIncome: String {
//            let calendar = Calendar.current
//            let weekDay = calendar.component(.weekday, from: iir.date)
//            
//            return "\(weekDay)"
//        }
//        
//        return dateIncome
//    }
//}
