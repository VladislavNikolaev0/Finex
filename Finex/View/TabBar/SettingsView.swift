//
//  SettingsView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 06.01.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    @State private var selectedScheme: Theme = .systemDefault
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("currency") private var currency: Currency = .ruble
    @State private var currencyIndex: Currency = .ruble
    @State private var showingAddCategoryView = false
    @Namespace private var animation
    
    var body: some View {
            List{
                HStack(spacing: 0){
                    ForEach(Theme.allCases, id:\.rawValue){ theme in
                        let isSelected = selectedScheme == theme
                        ZStack{
                            Rectangle()
                                .fill(.primary.opacity(0.2))
                                .frame(width: 85)
                            Rectangle()
                                .fill(userTheme == .glass ? .clear : .picker)
                                .cornerRadius(20)
                                .glass(cornerRadius: 20)
                                .padding(2)
                                .opacity(selectedScheme == theme ? 1 : 0.01)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.5, blendDuration: 5.5)){
                                        selectedScheme = theme
                                        userTheme = theme
                                    }
                                }
                                
                        }
                        .overlay(
                            Text(theme.rawValue.localized(language.rawValue))
                                .foregroundColor(isSelected ? .paleGreen : .primary)
                                
                        )
                    }
                }
                .themeRowBackground(theme: userTheme)
                .cornerRadius(20)
                HStack{
                    Text("language".localized(language.rawValue));
                    Spacer()
                    Menu{
                        Button(action: {
                            LocalizationService.shared.language = .russian
                        }){
                            Text("Русский")
                        }
                        .background(.green)
                        
                        Button(action: {
                            LocalizationService.shared.language = .english_us
                        }){
                            Text("English")
                        }
                        
                        Button(action:{
                            LocalizationService.shared.language = .chines
                        }){
                            Text("简体中文")
                        }
                        
                    } label: {
                        Text("languageType".localized(language.rawValue))
                            .foregroundColor(.paleGreen)
                    }
                    
                }.themeRowBackground(theme: userTheme)
                HStack{
                    Text("currency".localized(language.rawValue))
                    Spacer()
                    Menu{
                        Button(action: {
                            currency = .ruble
                        }) {
                            Text("₽")
                        }
                        Button(action: {
                            currency = .dollar
                        }){
                            Text("$")
                        }
                        Button(action: {
                            currency = .yean
                        }){
                            Text("¥")
                        }
                    } label:{
                        Text(currency == .ruble ? "₽" : (currency == .dollar ? "$" : "¥"))
                            .foregroundColor(.paleGreen)
                    }
                }.themeRowBackground(theme: userTheme)
                HStack{
                    Text("newCategory".localized(language.rawValue))
                    Spacer()
                    Button(action:{
                        self.showingAddCategoryView.toggle()
                    }){
                        Text("add".localized(language.rawValue))
                            .foregroundColor(.paleGreen)
                    }.sheet(isPresented: $showingAddCategoryView, content: {
                        CreateCategry().environmentObject(Cost()).environmentObject(Income())
                    })
                }.themeRowBackground(theme: userTheme)
                
                
            }
            .scrollContentBackground(userTheme == .glass ? .hidden : .visible)
            .background{
                if userTheme == .glass {
                    Image("finexBg")
                        .resizable()
                        .ignoresSafeArea()
                        .frame(height: UIScreen.main.bounds.height - 20)
                }
            }
            .preferredColorScheme(userTheme.colorScheme)
    }
    
}

#Preview {
    SettingsView()
}
