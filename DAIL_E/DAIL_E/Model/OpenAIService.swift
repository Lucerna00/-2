//
//  OpenAIService.swift
//  chatgpt_v2
//
//  Created by Sherzod Makhmudov on 2023/04/23.
//

import Foundation
import Alamofire

class OpenAIService{
    private let end_URL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages, stream: false)
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIKey)"
        ]
        return try? await AF.request(end_URL, method: .post, parameters: body, encoder: .json, headers: header).serializingDecodable(OpenAIChatResponse.self).value
    }
    
    func sendStreamMessage(messages: [Message]) -> DataStreamRequest {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages, stream: true)
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIKey)"
        ]
        return AF.streamRequest(end_URL, method: .post, parameters: body, encoder: .json, headers: header)
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
    let stream: Bool
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
