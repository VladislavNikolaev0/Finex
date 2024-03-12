//
//  CreateCategry.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 22.02.2024.
//

import SwiftUI

struct CreateCategry: View {
    
    private let forPicker = ["waste", "income"]
    private let forChoseIcon = ["pencil", "paperplane.fill", "doc.fill", "graduationcap.fill", "person.fill", "photo.artframe", "dumbbell.fill", "trophy.fill", "command", "powersleep", "keyboard.fill", "zzz", "sparkles", "cloud.fill", "snowflake", "drop.fill", "heart.fill", "checkmark.seal.fill", "shield.fill", "bolt.fill", "phone.fill", "envelope.fill", "gear", "cart.fill", "theatermasks.fill", "lightbulb.fill", "balloon.fill", "building.2.fill", "wifi", "display", "fish.fill", "pawprint.fill", "teddybear.fill", "cup.and.saucer.fill", "atom", "dollarsign.arrow.circlepath", "banknote.fill", "bitcoinsign", "wrench.fill", "logo.xbox", "fork.knife", "car.fill", "house.fill", "airplane", "gift.fill", "tag.fill", "dollarsign.circle.fill", "creditcard.circle.fill"]
    private let forChoseColor = ["greenBeige", "hipsNymph", "turquoiseBlue", "bisque", "paleMagenta", "vanilla", "gainsboro", "whiteSmoke", "melon", "amaranthPick", "antiqueBrass", "corn", "dollarBill", "indianRed", "magicMint", "royalBlue", "royalPurple"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 6)
    @State private var selectPicker = 0
    @State private var selectIcon = 0
    @State private var selectColor = 0
    @State private var textCategory = ""
    @State private var offsetX: CGFloat = .zero
    @State private var draggedIndex: Int?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var income: Income
    @EnvironmentObject var cost: Cost
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        VStack{
            Capsule()
                .frame(width: 60, height: 5)
                .foregroundColor(Color("bg"))
                .padding(.top, 10)
            VStack(alignment: .trailing){
                Button(action: {
                    if selectPicker == 0 {
                        withAnimation{
                            cost.addCategory(icon: forChoseIcon[selectIcon], color: forChoseColor[selectColor], title: textCategory)
                        }
                    } else {
                        withAnimation{
                            income.addCategory(icon: forChoseIcon[selectIcon], color: forChoseColor[selectColor], title: textCategory)
                        }
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    ZStack{
                        Capsule()
                            .frame(width: 120, height: 30)
                            .foregroundColor(.paleGreen)
                        Text("save".localized(language.rawValue))
                            .foregroundColor(.picker)
                            .fontWeight(.bold)
                    }.padding(.leading, 230)
                }
                
                Picker(selection: $selectPicker, label: Text("select")){
                    ForEach(0..<2){
                        Text(self.forPicker[$0].localized(language.rawValue))
                    }
                }.pickerStyle(.segmented)
                    .padding(.top)
            }
            .padding(.horizontal)
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    Text("icon".localized(language.rawValue))
                        .padding(.leading)
                        .font(.title)
                    LazyVGrid(columns: columns, spacing: 10){
                        ForEach(0..<forChoseIcon.count, id: \.self){ number in
                            Button(action:{
                                withAnimation{
                                    selectIcon = number
                                }
                            }){
                                ZStack{
                                    Circle()
                                        .frame(width: 32)
                                        .foregroundColor(selectIcon == number ? .paleGreen.opacity(0.15) : .clear)
                                    Image(systemName: forChoseIcon[number])
                                        .foregroundColor(selectIcon == number ? .paleGreen : .primary.opacity(0.6))
                                        .scaleEffect(1.3)
                                }
                            }
                        }
                    }
                    Text("color".localized(language.rawValue))
                        .padding(.leading)
                        .font(.title)
                    LazyVGrid(columns: columns, spacing: 10){
                        ForEach(0..<forChoseColor.count, id: \.self){ number in
                            Button(action: {
                                withAnimation{
                                    selectColor = number
                                }
                            }){
                                ZStack{
                                    Circle()
                                        .frame(width: 35)
                                        .foregroundColor(selectColor == number ? Color(forChoseColor[number]) : .clear)
                                    Circle()
                                        .frame(width: 30)
                                        .foregroundColor(.clear)
                                    Circle()
                                        .frame(width: 25)
                                        .foregroundColor(Color(forChoseColor[number]))
                                }
                            }
                        }
                    }
                    TextField("titleCategory".localized(language.rawValue), text: $textCategory)
                        .padding()
                        .font(.title)
                        .fontWeight(.bold)
                        .glass(cornerRadius: 5)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 40)
                        .offset(x: 10)
                        .padding(.vertical, 40)
                    Text("yourCategoryes".localized(language.rawValue))
                        .padding(.leading)
                        .font(.title)
                    VStack{
                        if selectPicker == 0 {
                            ForEach(0..<cost.gettCount(), id: \.self){ number in
                                ZStack(alignment: .trailing){
                                    
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(Color(cost.categories[number].color))
                                        .offset(x: 50)
                                        .offset(x: draggedIndex == number ? offsetX * 0.2 : .zero)
                                        .scaleEffect(draggedIndex == number ? CGSize(width: 0.3 * -offsetX * 0.03, height: 0.3 * -offsetX * 0.03) : .zero)
                                    
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                                        .cornerRadius(5)
                                        .foregroundColor(userTheme == .glass ? .clear : .picker)
                                        .glass(cornerRadius: 10)
                                    HStack{
                                        Image(systemName: cost.categories[number].icon)
                                            .foregroundColor(Color(cost.categories[number].color))
                                            .padding(.leading, 15)
                                        Spacer()
                                        Text(cost.categories[number].title.localized(language.rawValue))
                                            .font(.title2)
                                            .foregroundColor(Color(cost.categories[number].color))
                                            .padding(.trailing, 15)
                                        Spacer()
                                    }
                                    
                                }
                                
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(cost.categories[number].color),lineWidth: 4))
                                .padding(.trailing)
                                .offset(x: draggedIndex == number ? offsetX : .zero)
                                .gesture(DragGesture()
                                    .onChanged{ value in
                                        if value.translation.width < 0 && number >= 6{
                                            draggedIndex = number
                                            offsetX = value.translation.width
                                        }
                                    }
                                    .onEnded{ value in
                                        withAnimation{
                                            if screenSize().width * 0.6 < -value.translation.width {
                                                offsetX = -screenSize().width * 2
                                                cost.deleteCategories(categoryTitile: cost.categories[number].title)
                                            } else {
                                                offsetX = .zero
                                            }
                                            
                                        }
                                        draggedIndex = nil
                                    }
                                )
                            }
                        } else {
                            ForEach(0..<income.getCount(), id: \.self){ number in
                                ZStack(alignment: .trailing){
                                    
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(Color(income.categories[number].color))
                                        .offset(x: 50)
                                        .offset(x: draggedIndex == number ? offsetX * 0.2 : .zero)
                                        .scaleEffect(draggedIndex == number ? CGSize(width: 0.3 * -offsetX * 0.03, height: 0.3 * -offsetX * 0.03) : .zero)
                                    
                                    Rectangle()
                                        .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                                        .cornerRadius(5)
                                        .foregroundColor(userTheme == .glass ? .clear : .picker)
                                        .glass(cornerRadius: 10)
                                    
                                    HStack{
                                        Image(systemName: income.categories[number].icon)
                                            .foregroundColor(Color(income.categories[number].color))
                                            .padding(.leading, 15)
                                        Spacer()
                                        Text(income.categories[number].title.localized(language.rawValue))
                                            .font(.title2)
                                            .foregroundColor(Color(income.categories[number].color))
                                            .padding(.trailing, 15)
                                        Spacer()
                                    }
                                    
                                    
                                }
                                
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(income.categories[number].color),lineWidth: 4))
                                .padding(.trailing)
                                .offset(x: draggedIndex == number ? offsetX : .zero)
                                .gesture(DragGesture()
                                    .onChanged{ value in
                                        if value.translation.width < 0 && number >= 3{
                                            draggedIndex = number
                                            offsetX = value.translation.width
                                        }
                                    }
                                    .onEnded{ value in
                                        withAnimation{
                                            if screenSize().width * 0.6 < -value.translation.width {
                                                offsetX = -screenSize().width * 2
                                                income.daleteCategories(categoryTitle: income.categories[number].title)
                                                
                                            } else {
                                                offsetX = .zero
                                            }
                                            
                                        }
                                        draggedIndex = nil
                                    }
                                )
                            }
                        }
                    }.padding(.leading)
                }
            }
        }
        .background{
            if userTheme == .glass {
                Image("finexBg")
                    .resizable()
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(height: UIScreen.main.bounds.height)
            }
        }
    }
}

#Preview {
    CreateCategry().environmentObject(Income()).environmentObject(Cost())
}
