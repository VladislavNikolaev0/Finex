//
//  BudgetView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 09.01.2024.
//

import SwiftUI

struct BudgetView: View {
    
    @State var numberForBudget: String = ""
    @EnvironmentObject var budget: Budget
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 60, height: 5)
                .foregroundColor(Color("bg"))
            VStack(alignment: .trailing) {
                Button(action:{
                    if let actualAmount = Int(self.numberForBudget){
                        let amount = BudgetItem(budget: actualAmount)
                        guard !budget.budget.isEmpty else {
                            self.budget.budget.append(amount)
                            self.presentationMode.wrappedValue.dismiss()
                            return
                        }
                        self.budget.budget[0] = amount
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
                        
                    }.padding(.leading, 230)
                }
                VStack(alignment: .leading){
                    Text("purpose".localized(language.rawValue))
                        .font(.title)
                        .fontWeight(.heavy)
                }
                .padding(.trailing, 85)
                TextField("budget".localized(language.rawValue), text: $numberForBudget)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 60)
                    .font(.title)
                    .fontWeight(.bold)
                    .keyboardType(.numberPad)
                    .glass(cornerRadius: 5)
                Spacer()
                
            }
            .padding()
            
        }
        .background{
            if userTheme == .glass {
                Image("finexBg")
                    .resizable()
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(height: UIScreen.main.bounds.height - 100)
            }
        }
        .padding(.top, 20)
    }
}

struct BudgetView_Previews: PreviewProvider {
    static let budget = Budget()
    
    static var previews: some View {
        BudgetView().environmentObject(budget)
    }
}
