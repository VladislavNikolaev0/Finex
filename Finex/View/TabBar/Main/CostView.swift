//
//  CostView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 10.01.2024.
//

import SwiftUI
import RealmSwift
import VisionKit

struct CostView: View {
    
    private let forPicker = ["waste", "income"]
    @State private var selectPicker = 0
    @State private var selectCategory = 0
    @State private var costCategory = ""
    @State private var showCameraScannerView = false
    @State private var isDeviceCapacity = false
    @State private var showDeviceNotCapacityAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    @ObservedResults(IncomeItem.self) var incomeItems
    @ObservedResults(CostItem.self) var costItems
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        VStack{
            Capsule()
                .frame(width: 60, height: 5)
                .foregroundColor(Color("bg"))
            VStack(alignment: .trailing){
                HStack {
                    Button(action: {
                        if isDeviceCapacity {
                            self.showCameraScannerView = true
                        } else {
                            self.showDeviceNotCapacityAlert = true
                        }
                    }){
                        ZStack{
                            Image(systemName: "barcode.viewfinder")
                                .resizable()
                                .frame(width: 30, height: 25)
                                .foregroundColor(.paleGreen)
                            Rectangle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(userTheme == .glass ? .purple.opacity(0.6) : .picker)
                            Text("10")
                                .foregroundColor(.paleGreen)
                                
                        }
                    }
                    .sheet(isPresented: $showCameraScannerView) {
                        CameraScanner(startScanning: $showCameraScannerView, scanResult: $costCategory)
                    }
                    .alert("Scaner unavailable", isPresented: $showDeviceNotCapacityAlert, actions: {})
                    .onAppear {
                        isDeviceCapacity = (DataScannerViewController.isSupported && DataScannerViewController.isAvailable)
                    }
                    
                    Spacer()
                    
                    Button(action:{
                        if selectPicker == 0 {
                            
                            let newCost = CostItem()
                            newCost.cat = selectCategory
                            newCost.cost = Int(costCategory)!
                            newCost.date = Date()
                            
                            $costItems.append(newCost)
                            
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            
                            let newIcome = IncomeItem()
                            newIcome.cat = selectCategory
                            newIcome.income = Int(costCategory)!
                            newIcome.date = Date()
                            
                            $incomeItems.append(newIcome)
                            
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }){
                        ZStack{
                            Capsule()
                                .frame(width: 120, height: 30)
                                .foregroundColor(Color("paleGreen"))
                            Text("save".localized(language.rawValue))
                                .foregroundColor(.picker)
                                .fontWeight(.bold)
                            
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40)
                .padding(.bottom, 20)
                VStack(alignment: .leading){
                    if (selectPicker == 0){
                        Text("newWaste".localized(language.rawValue))
                            .font(.headline)
                            .fontWeight(.bold)
                            .scaleEffect(2)
                            .padding(.trailing, 160)
                    } else {
                        Text("newIncome".localized(language.rawValue))
                            .font(.headline)
                            .fontWeight(.bold)
                            .scaleEffect(2)
                            .padding(.trailing, 171)
                    }
                }
                
                Picker(selection: $selectPicker, label: Text("Select cost of income")){
                    ForEach(0..<2){
                        Text(self.forPicker[$0].localized(language.rawValue))
                    }
                }
                .pickerStyle(.segmented)
                .glass(cornerRadius: 5)
                .padding(.top, 20)
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false){
                if (selectPicker == 0) {
                    HStack(spacing: -10){
                        ForEach(0..<cost.gettCount(), id: \.self){ number in
                            Button(action:{
                                selectCategory = number
                            }){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 230, height:  50)
                                        .cornerRadius(5)
                                        .foregroundColor(self.selectCategory == number ? Color(cost.categories[number].color) : (userTheme == .glass ? .picker.opacity(0) : .picker))
                                        .glass(cornerRadius: 10)
                                    HStack{
                                        Image(systemName: cost.categories[number].icon)
                                            .foregroundColor(self.selectCategory == number ? .picker : Color(cost.categories[number].color))
                                            .padding(.leading, 15)
                                        Spacer()
                                        Text(cost.categories[number].title.localized(language.rawValue))
                                            .font(.title2)
                                            .foregroundColor(self.selectCategory == number ? .picker : Color(cost.categories[number].color))
                                            .padding(.trailing, 15)
                                        Spacer()
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(cost.categories[number].color),lineWidth: 2))
                            }
                            .padding(.leading, 10)
                        }
                        .padding(5)
                    }
                } else {
                    HStack(spacing: -10){
                        ForEach(0..<income.getCount(), id: \.self){ number in
                            Button(action:{
                                selectCategory = number
                            }){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 230, height:  50)
                                        .cornerRadius(5)
                                        .foregroundColor(self.selectCategory == number ? Color(income.categories[number].color) : (userTheme == .glass ? .picker.opacity(0) : .picker))
                                        .glass(cornerRadius: 10)
                                    HStack{
                                        Image(systemName: income.categories[number].icon)
                                            .foregroundColor(self.selectCategory == number ? .picker : Color(income.categories[number].color))
                                            .padding(.leading, 15)
                                            .scaleEffect(1.3)
                                        Spacer()
                                        Text(income.categories[number].title.localized(language.rawValue))
                                            .font(.title2)
                                            .foregroundColor(self.selectCategory == number ? .picker : Color(income.categories[number].color))
                                            .padding(.trailing, 15)
                                        Spacer()
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(income.categories[number].color),lineWidth: 2))
                            }
                            .padding(.leading, 10)
                        }
                        .padding(5)
                    }
                }
            }
            .padding(.vertical, 10)
            TextField("sum".localized(language.rawValue), text: $costCategory)                
                .frame(width: 350, height: 60)
                .font(.title)
                .fontWeight(.bold)
                .keyboardType(.numberPad)
                .glass(cornerRadius: 5)
            Spacer()
        }
        .padding(.top)
        .background{
            if userTheme == .glass {
                Image("finexBg")
                    .resizable()
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(height: UIScreen.main.bounds.height - 100)
            }
        }
    }
}

struct CostView_Previews: PreviewProvider {
    static let income = Income()
    static let cost = Cost()
    
    static var previews: some View{
        CostView().environmentObject(income).environmentObject(cost)
    }
}
