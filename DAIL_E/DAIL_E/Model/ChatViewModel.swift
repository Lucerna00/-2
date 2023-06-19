//
//  ChatViewModel.swift
//  chatgpt_v2
//
//  Created by Sherzod Makhmudov on 2023/04/23.
//

import Foundation

extension ChatView{
    class ViewModel: ObservableObject{
        @Published var messages: [Message] = [Message(id: "First message", role: .system, content: "You are going to help learners to get conversation skill. So you just have to keep the conversation going.", createAt: Date())]
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()
        func sendMessage(){
            let newMessage = Message(id: UUID().uuidString, role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            openAIService.sendStreamMessage(messages: messages).responseStreamString {[weak self] stream in
                guard let self = self else { return }
                switch stream.event{
                case .stream(let response):
                    switch response {
                    case .success(let string):
                        let streamResponse = self.parseStreamData(string)
                        
                        streamResponse.forEach {newMessageResponse in
                            guard let messageContent = newMessageResponse.choices.first?.delta.content else {
                                return
                            }
                            guard let existingMessageIndex = self.messages.lastIndex(where: {$0.id == newMessageResponse.id}) else {
                                let newMessage = Message(id: newMessageResponse.id, role: .assistant, content: messageContent, createAt: Date())
                                self.messages.append(newMessage)
                                return
                            }
                            let newMessage = Message(id: newMessageResponse.id, role: .assistant, content: self.messages[existingMessageIndex].content + messageContent, createAt: Date())
                            self.messages[existingMessageIndex] = newMessage
                        }
                    case .failure(_):
                        print("Failed")
                    }
                    print(response)
                case .complete(_):
                    print("Complete")
                }
            }
        }
        
        func parseStreamData(_ data: String) -> [ChatStreamCompletionResponse]{
            let responseString = data.split(separator: "data:").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)}).filter({!$0.isEmpty})
            let jsonDecoder = JSONDecoder()
            
            return responseString.compactMap { jsonString in
                guard let jsonData = jsonString.data(using: .utf8), let streamResponse = try? jsonDecoder.decode(ChatStreamCompletionResponse.self, from: jsonData) else {
                    return nil
                }
                return streamResponse
            }
        }
    }
}

struct Message: Decodable{
    let id: String
    let role: SenderRole
    let content: String
    let createAt: Date
}


struct ChatStreamCompletionResponse: Decodable {
    let id: String
    let choices: [ChatStreamChoice]
}

struct ChatStreamChoice: Decodable {
    let delta: ChatStreamContent
}

struct ChatStreamContent: Decodable {
    let content: String
}
