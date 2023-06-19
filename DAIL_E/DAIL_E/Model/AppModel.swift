//
//  AppModel.swift
//  chatgpt_v2
//
//  Created by Sherzod Makhmudov on 2023/06/04.

import SwiftUI
import OpenAISwift

final class AppModel: ObservableObject {
    @Published var isThinking: Bool = false
    @Published var generatedWords: String = ""
    @Published var wordArray: [String?] = []
    @Published var meanArray: [String?] = []
    var messages = [ChatMessage]()
    @Published var wordMap: [String: String] = [:]
    
    private var client: OpenAISwift = OpenAISwift(authToken: Constants.openAIKey)
    
    func initPrompt(){
        messages.append(ChatMessage(role: .system, content: "From now on all of your response is inside json structure I provide below. Give me ten random toeic words with their korean translation next to it. If i say refresh generate new answer. The JSON structure is as \"word1\":\"meaning\",\"word2\":\"meaning\",\"word3\":\"meaning\",\"word4\":\"meaning\",\"word5\":\"meaning\",\"word6\":\"meaning\",\"word7\":\"meaning\",\"word8\":\"meaning\",\"word9\":\"meaning\",\"word10\":\"meaning\"}"))
    }
    
    private func send()   {
        messages.append(ChatMessage(role: .user, content: "refresh"))
        isThinking = true
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
                isThinking = false
                print(error.localizedDescription)
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
