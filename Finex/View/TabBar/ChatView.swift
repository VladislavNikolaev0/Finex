//
//  ChatView.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 01.03.2024.
//

import SwiftUI
import Combine
import RealmSwift

struct ChatView: View {
    
    @State private var chatMassage: [ChatMassage] = []
    @State private var messageText: String = ""
    @State private var cancellables = Set<AnyCancellable>()
    @State private var date = Date()
    @EnvironmentObject var cost: Cost
    @ObservedResults(CostItem.self) var costItems
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @AppStorage("language") private var language = LocalizationService.shared.language
    @AppStorage("currency") private var currency: Currency = .ruble
    let openAISecvice = OpenAIService()
    
    var body: some View {
        VStack {
            ScrollView{
                LazyVStack{
                    ForEach(chatMassage, id: \.id){ message in
                        messageView(message: message, theme: userTheme)
                    }
                }
            }
            .gesture(DragGesture().onChanged { _ in
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            HStack{
                Menu{
                    Button(action: {
                        let costCats: [Int] = getDataCost(date: date, items: costItems)
                        if language == .russian {
                            messageText = "Проанализируй мои расходы: " + getAnaliz(cost: cost, costCats: costCats) + " подскажи, на чем можно экономить"
                            sendMessage()
                        }
                        if language == .english_us {
                            messageText = "Analyze my expenses: " + getAnaliz(cost: cost, costCats: costCats) + " and tell me, what can I save on?"
                            sendMessage()
                        }
                        if language == .chines {
                            messageText = "请分析我的费用: " + getAnaliz(cost: cost, costCats: costCats) + " 请给我一条建议，得节省什么钱"
                        }
                    }){
                        Text("analiz".localized(language.rawValue))
                    }
                    Button(action: {
                        if language == .russian {
                            messageText = "Как можно сократить расходы?"
                            sendMessage()
                        }
                        if language == .english_us {
                            messageText = "Please give me some advice on what can I save and on what shouldn't?"
                            sendMessage()
                        }
                        if language == .chines {
                            messageText = "请给我一条建议，得节省什么钱也不得节省什么的？"
                            sendMessage()
                        }
                    }){
                        Text("advice".localized(language.rawValue))
                    }
                    Button(action: {
                        if language == .russian {
                            messageText = "Почему стоит экономить?"
                            sendMessage()
                        }
                        if language == .english_us {
                            messageText = "Why it's worth saving?"
                            sendMessage()
                        }
                        if language == .chines {
                            messageText = "为什么要省钱？"
                            sendMessage()
                        }
                    }){
                        Text("why".localized(language.rawValue))
                    }
                } label: {
                    Image(systemName: "paperclip")
                        .foregroundColor(.picker)
                        .padding(10)
                        .background(.paleGreen)
                        .cornerRadius(10)
                }
                TextField("enterMessage".localized(language.rawValue), text: $messageText)
                    .padding(10)
                    .background(userTheme == .glass ? .bg.opacity(0) : .bg.opacity(0.7))
                    .glass(cornerRadius: 10)
                    .cornerRadius(10)
                Button(action: {
                    sendMessage()
                }){
                    Image(systemName: "arrow.turn.down.left")
                        .foregroundColor(.picker)
                        .padding(13)
                        .background(.paleGreen)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.bottom, 70)
        .background{
            if userTheme == .glass {
                Image("finexBg")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
        }
        .padding()
    }
    
    func messageView(message: ChatMassage, theme: Theme) -> some View {
        HStack{
            if message.sender == .user { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .user ? .white : .primary)
                .padding()
                .background(theme == .glass ? (message.sender == .user ? .paleGreen.opacity(0.85) : .bg.opacity(0)) : (message.sender == .user ? .paleGreen.opacity(0.85) : .bg))
                .glass(cornerRadius: 10)
                .cornerRadius(10)
            if message.sender == .gpt { Spacer() }
        }
    }
    
    func sendMessage() {
        let userMessage = ChatMassage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .user)
        chatMassage.append(userMessage)
        
        openAISecvice.sendMessage(message: messageText).sink { completion in
            //error
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            let gptMessage = ChatMassage(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
            chatMassage.append(gptMessage)
        }.store(in: &cancellables)
        print(messageText)
        messageText = ""
    }
    
    func getDataCost(date: Date, items: Results<CostItem>) -> [Int] {
        var result = Array(repeating: 0, count: cost.gettCount())

        items.filter { Int($0.textDateMonth!) == Int(nowMonth(date: self.date)) }
             .forEach { elem in
                 if elem.cat < cost.gettCount() {
                     result[elem.cat] += Int(elem.cost)
                 }
             }

        return result
    }
    
    func nowMonth(date: Date) -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        return "\(month)"
    }
    
    func getAnaliz(cost: Cost, costCats: [Int]) -> String {
        var message = ""
        
        for i in 0..<cost.gettCount() {
            message += "\(cost.categories[i].title.localized(language.rawValue)) - \(costCats[i]) \(currency.rawValue) "
        }
        
        return message
    }
}

#Preview {
    ChatView()
}
