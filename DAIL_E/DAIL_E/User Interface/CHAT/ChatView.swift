//
//  ContentView.swift
//  chatgpt_v2
//
//  Created by Sherzod Makhmudov on 2023/04/23.
//

import SwiftUI

struct ChatView: View {
    @Binding var detailCHAT:Bool
    @Binding var CHATProgress:CGFloat
    @ObservedObject var viewModel = ViewModel()
    // used for systeme theme mode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            NavigationBar(isDetail: $detailCHAT, preTitle: "Home", curTitle: "CHAT")
            
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id){ message in
                    messageView(message: message)
                }
            }
            .padding(30)
            
            HStack {
                TextField("Enter a message..", text: $viewModel.currentInput)
                Button{
                    viewModel.sendMessage()
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(Color.mainColor)
                        .font(.title2)
                }
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 40, trailing: 30))
            .background(Color.white)
            .shadow(color:.lightGray, radius: 20, y:-5)
        }
        .ignoresSafeArea()
        .background(.white)
    }
    
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user {Spacer()}
            Text(message.content)
                .padding(15)
                .foregroundColor(message.role == .user ? .white: colorScheme == .dark ? .white: .black)
                .background(message.role == .user ? Color.mainColor: Color.lightGray)
                .cornerRadius(message.role == .user ? 30 : 0, corners: .topLeft)
                .cornerRadius(message.role == .user ? 0 : 30, corners: .topRight)
                .cornerRadius(30, corners: .bottomLeft)
                .cornerRadius(30, corners: .bottomRight)
                .padding([.bottom], 15)
            if message.role == .assistant {Spacer()}
        }
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(detailCHAT: .constant(true), CHATProgress: .constant(0))
    }
}
