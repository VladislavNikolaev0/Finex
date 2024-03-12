//
//  VMOpenAI.swift
//  Finex
//
//  Created by Vladislav Nikolaev on 12.03.2024.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAICompetionsRersponse, Error>{
        let body = OpenAICompletionBody(model: "gpt-3.5-turbo-instruct", prompt: message, temperature: 0.7, max_tokens: 800)

        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Constants.openAIAPIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompetionsRersponse.self) { response in
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
                print(response.result)
            }
        }.eraseToAnyPublisher()
    }
}
