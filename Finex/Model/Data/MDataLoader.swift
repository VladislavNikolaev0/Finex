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

//class Income: ObservableObject {
//    
//    @Published var items = [IncomeItem]()
//    @Published var categories: [CategoryIncome] = [] {
//        didSet {
//            saveCategories()
//        }
//    }
//    
//    init() {
//        loadCategories()
//    }
//    
//    func loadCategories() {
//        if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("incomeCategories.json"),
//           let categoriesData = try? Data(contentsOf: documentURL) {
//            if let localCategories = try? JSONDecoder().decode([CategoryIncome].self, from: categoriesData){
//                categories = localCategories
//            } else {
//                fatalError("Can't load categories income from document directory")
//            }
//        } else {
//            let url = Bundle.main.url(forResource: "incomeCategories", withExtension: "json")!
//            
//            let categoriesData = try! Data(contentsOf: url)
//            guard let localCategorories = try? JSONDecoder().decode([CategoryIncome].self, from: categoriesData) else {
//                fatalError("Can't load categories income")
//            }
//            
//            categories = localCategorories
//        }
//    }
//    
//    func addCategory(icon: String, color: String, title: String) {
//        let newCategory = CategoryIncome(icon: icon, color: color, title: title)
//        
//        categories.append(newCategory)
//    }
//    
//    func saveCategories() {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        
//        if let jsonData = try? encoder.encode(categories),
//           let jsonString = String(data: jsonData, encoding: .utf8) {
//            if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("incomeCategories.json"){
//                do {
//                    try jsonString.write(to: url, atomically: true, encoding: .utf8)
//                } catch {
//                    fatalError("Failed to save categories to file: \(error)")
//                }
//            }
//        }
//    }
//    
//    func daleteCategories(categoryTitle: String) {
//        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
//            categories.remove(at: index)
//        }
//        
//        saveCategories()
//    }
//    
//    func getCount() -> Int {
//        return categories.count
//    }
//}

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

//class Cost: ObservableObject {
//    
//    @Published var items = [CostItem]()
//    @Published var categoriesIcons = ["fork.knife", "car.fill", "house.fill", "airplane", "gift.fill", "tag.fill"]
//    @Published var categoriesColors: [Color] = [Color("corn"), Color("indianRed"), Color("royalBlue"), Color("magicMint"), Color("amaranthPick"), Color("royalPurple")]
//    @Published var categoriesTitels = ["eat", "transport", "house", "travel", "present", "other"]
//    @Published var categories: [CategoryCost] = [] {
//        didSet{
//            saveCategories()
//        }
//    }
//    
//    init(){
//        loadCategories()
//    }
//    
//    func loadCategories() {
//        if let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("costCategories.json"),
//           let categoriesData = try? Data(contentsOf: documentURL) {
//            
//            if let localCategories = try? JSONDecoder().decode([CategoryCost].self, from: categoriesData) {
//                categories = localCategories
//            } else {
//                fatalError("Can't load categories cost from document directory")
//            }
//        } else {
//            let url = Bundle.main.url(forResource: "costCategories", withExtension: "json")!
//            
//            let categoriesData = try! Data(contentsOf: url)
//            guard let localCategories = try? JSONDecoder().decode([CategoryCost].self, from: categoriesData) else {
//                fatalError("Can't load categories cost")
//            }
//            
//            categories = localCategories
//        }
//    }
//    
//    func addCategory(icon: String, color: String, title: String){
//        let newCategory = CategoryCost(icon: icon, color: color, title: title)
//        
//        categories.append(newCategory)
//        
//    }
//    
//    func saveCategories() {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        
//        if let jsonData = try? encoder.encode(categories),
//           let jsonString = String(data: jsonData, encoding: .utf8) {
//            if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("costCategories.json") {
//                do {
//                    try jsonString.write(to: url, atomically: true, encoding: .utf8)
//                } catch {
//                    fatalError("Failed to save categories to file: \(error)")
//                }
//            }
//        }
//    }
//    
//    func deleteCategories(categoryTitile: String) {
//        if let index = categories.firstIndex(where: {$0.title == categoryTitile}) {
//            categories.remove(at: index)
//        }
//        
//        saveCategories()
//    }
//    
//    func gettCount() -> Int {
//        return categories.count
//    }
//}

struct BudgetItem: Identifiable, Codable{
    var id = UUID()
    let budget: Int
}

//class Budget : ObservableObject{
//    @Published public var budget = [BudgetItem](){
//        didSet{
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(budget){
//                UserDefaults.standard.set(encoded, forKey: "budget")
//            }
//        }
//    }
//    init(){
//        if let budget = UserDefaults.standard.data(forKey: "budget"){
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode([BudgetItem].self, from: budget){
//                self.budget = decoded
//                return
//            }
//        }
//    }
//    
//    func getEnd() -> (Int){
//        print(budget.endIndex)
//        return budget.endIndex
//    }
//    
//    func getBudget() -> (Int){
//        guard !budget.isEmpty else {
//            return 0
//        }
//        return budget[0].budget
//    }
//
//    func first(){
//        budget[0] = BudgetItem(budget: 0)
//    }
//}
