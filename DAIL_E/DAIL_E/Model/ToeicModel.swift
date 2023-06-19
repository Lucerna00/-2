//
//  ToeicModel.swift
//  chatgpt_v2
//
//  Created by 김다훈 on 2023/06/09.
//

import SwiftUI
import OpenAISwift

final class ToeicModel: ObservableObject {
    @Published var isThinking: Bool = false
    @Published var questionArray: [String?] = []
    @Published var answerArray: [String?] = []
    var messages = [ChatMessage]()
    @Published var wordMap: [String: String] = [:]
    
    private var client: OpenAISwift = OpenAISwift(authToken: Constants.toeicAIKey)
    
    func initPrompt(){
        messages.append(ChatMessage(role: .system, content: "From now on all of your responses is inside json structure I provide below. Give me the Questions which should fill the blanks among the 4 sememtically or  grammarly different sentences for training TOEIC Part 5. Please print out only the alphabet among A, B, C, and D. If I say refresh generate a new question. The JSON structure is as \"question\":\"question 1\",\"a\":\"A) option\",\"b\":\"B) option\",\"c\":\"C) option\",\"d\":\"D) option\",\"result\":\"answer\"}. "))
    }
    
    func send()   {
        messages.append(ChatMessage(role: .user, content: "refresh"))
        isThinking=true
        Task {
            do {
                let result = try await client.sendChat(with: messages)
                messages.append(result.choices?.first?.message ?? ChatMessage(role: .assistant, content:"{}"))
                
                DispatchQueue.main.async {
                    self.wordMap = self.convertToDictionary(text: result.choices?.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? "{}") ?? [:]
                    self.isThinking = false
                    print(self.wordMap)
                }
                
            } catch {
//                isThinking=false
                DispatchQueue.main.async {
                    self.isThinking = false
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func makeWords() {
        send()
    }
    
    func convertToDictionary(text: String) -> [String: String]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    struct Response: Codable {
        let words: [Word]
    }
    
    struct Word: Codable {
        let word: String?
        let meaning: String?
    }
}

