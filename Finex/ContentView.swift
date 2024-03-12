//
//  ContentView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 04.01.2024.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    private let iconsTabBar = ["rublesign.circle", "list.triangle", "message.fill", "gear"]
    private let tabBarNames = ["tracker", "history", "chat", "settings"]
    @State private var selectTabBar = 0   
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @AppStorage("language") private var language = LocalizationService.shared.language
    private let realm = try! Realm()
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    let budget = Budget()
    
    var body: some View {
        ZStack(alignment: .bottom){
            GeometryReader{_ in
                switch selectTabBar{
                case 0: MainView().environmentObject(Income()).environmentObject(Cost()).environmentObject(budget)
                case 1: HistoryView()
                case 2: ChatView().environmentObject(Cost())
                default: SettingsView()
                }
            }
            HStack{
                ForEach(0..<4){number in
                    Spacer()
                    Button(action: {
                        withAnimation{
                            self.selectTabBar = number
                        }
                    }) {
                        VStack(spacing: 0){
                            Image(systemName: "\(iconsTabBar[number])")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(selectTabBar == number ? .paleGreen : (userTheme == .glass ? .black : .bg))
                            Text(tabBarNames[number].localized(language.rawValue))
                                .foregroundColor(selectTabBar == number ? .paleGreen : (userTheme == .glass ? .black : .bg))
                        }
                    }
                }
                Spacer()
            }
            .padding(.bottom, 25)
            .padding(.top, 10)
            .glass(cornerRadius: 0)
            .background{
                Rectangle()
                    .foregroundColor(userTheme == .glass ? .clear : .picker)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .modifier(KeyboardAdaptive())
        .preferredColorScheme(userTheme.colorScheme)
    }
}

#Preview {
    ContentView().environmentObject(Cost()).environmentObject(Income())
}
