//
//  ButtonsLostGetView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 03.02.2024.
//

import SwiftUI

struct ButtonsLostGetView: View {
    
    @Binding var selectExpenditure: Int
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("currency") private var currency: Currency = .ruble
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    var costCats: [Int]
    var incomeCats: [Int]
    
    var body: some View {
        HStack{
            Button(action:{
                withAnimation(.bouncy){
                    self.selectExpenditure = 0
                }
            }){
                ZStack{
                    Rectangle()
                        .frame(width: 168, height: 83)
                        .foregroundColor(userTheme == .glass ? .clear : .bg )
                        .opacity(selectExpenditure == 0 ? 1 : 0.4)
                        .cornerRadius(20)
                        .glass(cornerRadius: 20)
                    Rectangle()
                        .frame(width: 165, height: 80)
                        .foregroundColor(self.selectExpenditure == 0 ? (userTheme == .glass ? .picker.opacity(0.2) : .picker) : Color("lavenderLight"))
                        .cornerRadius(20)
                        .glass(cornerRadius: 20)
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "arrow.down")
                                .resizable()
                                .frame(width: 10, height: 13)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("paleGreen"))
                            Text("spend".localized(language.rawValue))
                                .foregroundStyle(Color("paleGreen"))
                        }
                        Text("\(costCats.reduce(0) { $0 + $1 }) \(currency.rawValue)")
                                                .foregroundColor(.primary)
                                                .font(.title2)
                    }
                    .padding(.trailing, 40)
                    .padding(.bottom, 10)
                }
            }
            Spacer(minLength: 0)
            Button(action: {
                withAnimation(.bouncy){
                    self.selectExpenditure = 1
                }
            }){
                ZStack{
                    Rectangle()
                        .frame(width: 168, height: 83)
                        .foregroundColor(userTheme == .glass ? .clear : .bg )
                        .opacity(selectExpenditure == 1 ? 1 : 0.4)
                        .cornerRadius(20)
                        .glass(cornerRadius: 20)
                    Rectangle()
                        .frame(width: 165, height: 80)
                        .foregroundColor(self.selectExpenditure == 1 ? (userTheme == .glass ? .picker.opacity(0.2) : .picker) : Color("lavenderLight"))
                        .cornerRadius(20)
                        .glass(cornerRadius: 20)
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "arrow.up")
                                .resizable()
                                .frame(width: 10, height: 13)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("paleGreen"))
                            Text("received".localized(language.rawValue))
                                .foregroundStyle(Color("paleGreen"))
                        }
                        Text("\(incomeCats.reduce(0) { $0 + $1 }) \(currency.rawValue)")
                            .foregroundColor(.primary)
                            .font(.title2)
                    }
                    .padding(.trailing, 40)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

#Preview {
    ButtonsLostGetView(selectExpenditure: .constant(0), costCats: [0, 0, 0, 0, 0, 0], incomeCats: [0, 0, 0])
}
