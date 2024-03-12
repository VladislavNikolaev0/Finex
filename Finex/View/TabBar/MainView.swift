//
//  MainView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 06.01.2024.
//

import SwiftUI
import VisionKit

struct MainView: View {
    
    @State private var selectTimeInterval = 0
    private let timeInterval = ["day", "week", "month", "year"]
    @State var showingCostView: Bool = false
    @State private var showCameraScannerView = false
    @State private var isDeviceCapacity = false
    @State private var showDeviceNotCapacityAlert = false
    @State private var scanResults: String = ""
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Spacer()
            
            GeometryReader{_ in
                switch selectTimeInterval{
                case 0: DayView().environmentObject(Cost()).environmentObject(Income())
                case 1: WeekView().environmentObject(Cost()).environmentObject(Income())
                case 2: MonthView().environmentObject(Cost()).environmentObject(Income())
                default: YearView().environmentObject(Cost()).environmentObject(Income())
                }
            }
            
            VStack {
                HStack{
                    Spacer()
                    Text("tracker".localized(language.rawValue))
                        .font(.title2)
                        .padding(.leading, 65)
                    Spacer()
                    Button(action: {
                        self.showingCostView.toggle()
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(.paleGreen)
                            .scaleEffect(1.3)
                    }.sheet(isPresented: $showingCostView, content: {
                        CostView()
                            .environmentObject(Cost())
                            .environmentObject(Income())
                            .presentationDetents([.height(450)])
                    })
                    .padding(.horizontal)
                }
                Picker(selection: $selectTimeInterval, label: Text("select time interval")){
                    ForEach(0..<4){
                        Text(self.timeInterval[$0].localized(language.rawValue))
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            .padding(.top, 40)
            .glass(cornerRadius: 0)
            .background{
                Rectangle()
                    .foregroundColor(userTheme == .glass ? .clear : .picker)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static let income = Income()
    static let cost = Cost()
    static let budget = Budget()
    
    static var previews: some View {
        MainView().environmentObject(income).environmentObject(cost).environmentObject(budget)
    }
}
