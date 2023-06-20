//
//  ChatViewModel.swift
//  chatgpt_v2
//
//  Created by Sherzod Makhmudov on 2023/04/23.
//

import Foundation

extension DiaryChatView{
    class DiaryModel: ObservableObject{
        @Published var diary_input: String = ""
        @Published var diary_msgs: [Message] = []
        @Published var command_feeling: String = ""
        @Published var diary_current_msg:String = ""
        @Published var first_response:String = ""
        private let openAIService = OpenAIService()
        init(input: String)
        {
            self.diary_input = input
            self.sendFirstMesseage()
        }
        
        func sendFirstMesseage()
        {
            command_feeling = "Please sympathize with the next sentence"
            command_feeling.append(diary_input)
            
            //메세지 생성
            let feelingmsg = Message(id: UUID().uuidString, role: .user, content: command_feeling, createAt: Date())
            //메세지 전송을 위한 배열&append
            var temp_first_msg: [Message] = []
            temp_first_msg.append(feelingmsg)
            //변수 초기화
            diary_input = ""
            //메세지 전송
            sendStreamMsg(meslist: temp_first_msg)
            
        }
        func sendMessage(){
            command_feeling = ""
            command_feeling.append(diary_input)
            let feelingmsg = Message(id: UUID().uuidString, role: .user, content: command_feeling, createAt: Date())
            diary_msgs.append(feelingmsg)
            diary_input = ""
            sendStreamMsg(meslist: diary_msgs)
            
        }
        
        //메세지 전송 function
        func sendStreamMsg(meslist: [Message])
        {
            openAIService.sendStreamMessage(messages: meslist).responseStreamString {[weak self] stream in
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
                            guard let existingMessageIndex = self.diary_msgs.lastIndex(where: {$0.id == newMessageResponse.id}) else {
                                let newMessage = Message(id: newMessageResponse.id, role: .assistant, content: messageContent, createAt: Date())
                                self.diary_msgs.append(newMessage)
                                return
                            }
                            let newMessage = Message(id: newMessageResponse.id, role: .assistant, content: self.diary_msgs[existingMessageIndex].content + messageContent, createAt: Date())
                            self.diary_msgs[existingMessageIndex] = newMessage
                            self.first_response = newMessage.content
                            
                        }
                        
                    case .failure(_):
                        print("Failed")
                    }
                    print(response)
                case .complete(_):
                    print("new msg from mod : \(self.first_response)")
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
