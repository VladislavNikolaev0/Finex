//
//  OpenAIService.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 01.03.2024.
//

import Foundation
import Alamofire
import Combine

struct OpenAICompletionBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}

struct OpenAICompetionsRersponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoice]
}
struct OpenAICompletionsChoice: Decodable {
    let text: String
}

enum Constants {
    static let openAIAPIKey = "your APIOpenAI key"
}
