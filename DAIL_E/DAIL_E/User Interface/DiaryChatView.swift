//
//  DiaryChatView.swift
//  chatgpt_v2
//
//  Created by 신영재 on 2023/05/03.
//

import SwiftUI

struct DiaryChatView: View {
//    static var input_diary: String = ""
//    @Binding var txt: String
    let firstinput_str: String
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var diarymodel: DiaryModel
    @State var Diary_info: DiaryInfo = DiaryInfo(date: "", place: "", contents: "", response: "")
    var contents_ : String
    var place_ : String
    var date_ : String
    var response_ : String
    
    init(input: String, date: String, place: String, contents: String, response: String) {
        print("DiaryChatView")
        firstinput_str = input
        diarymodel = DiaryModel(input: firstinput_str)
        contents_ = firstinput_str
        place_ = place
        date_ = date
        response_ = response
    }
    
    var body: some View {
        
        VStack {
            ScrollView {
                ForEach(diarymodel.diary_msgs.filter({$0.role != .system}), id: \.id){ message in
                    messageView(message: message)
                }
                
            }
//            HStack {
//                TextField("Enter a message..", text: $diarymodel.diary_current_msg)
//                Button{
//                    diarymodel.sendMessage()
//                } label: {
//                    Text("send")
//                }
//            }
            Button(action: {
                Diary_info.date = date_
                Diary_info.place = place_
                Diary_info.contents = contents_
                Diary_info.response = diarymodel.first_response
                testjson(info: Diary_info)
                if self.presentationMode.wrappedValue.isPresented {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Custom_Button(content: "Save", witdh: 130, height: 55)
            }
        }
        .padding()
            
        
    }
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user {Spacer()}
            Text(message.content)
                .padding(15)
                .foregroundColor(message.role == .user ? .white: .black)
                .background(message.role == .user ? Color.mainColor: Color.lightGray)
                .cornerRadius(message.role == .user ? 30 : 0, corners: .topLeft)
                .cornerRadius(message.role == .user ? 0 : 30, corners: .topRight)
                .cornerRadius(30, corners: .bottomLeft)
                .cornerRadius(30, corners: .bottomRight)
                .padding(EdgeInsets(top: 50, leading: 20, bottom: 30, trailing: 20))
            if message.role == .assistant {Spacer()}
        }
    }
}


struct DiaryChatView_Preview: PreviewProvider {
    static var previews: some View {
        DiaryChatView(input: "", date: "", place: "", contents: "", response: "")
    }
}
