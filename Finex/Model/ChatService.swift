//
//  ChatService.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 12.03.2024.
//

import Foundation

enum MessageSender {
    case user
    case gpt
}

struct ChatMassage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}
