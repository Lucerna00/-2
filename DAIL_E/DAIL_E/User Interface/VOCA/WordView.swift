//
//  Word.swift
//  DAIL_E
//
//  Created by Park on 2023/05/28.
//

import SwiftUI

struct WordView: View {
    @State var isMarked = false
    @State var isOpened = false
    var word:String
    var meaning:String
    
    var body: some View {
        VStack{
            // 북마크 버튼
            HStack{
                Spacer()
                Button(action: {
                    self.isMarked.toggle()
                    
                    if(isMarked){
                        dbHelper.insertVoca(word: word, meaning: meaning)
                    }
                    else{
                        dbHelper.deleteVoca(word: word)
                    }
                }) {
                    Image(systemName: isMarked ? "star.fill" : "star")
                        .foregroundColor(Color.yellow)
                }
            }
            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 20))
            
            // 영어 단어
            Text(word)
                .bold()
                .font(.title)
            
            // 소리 & 뜻 버튼
            HStack{
                Image("Sound")
                Spacer()
                Button(action: {
                    withAnimation {
                        self.isOpened.toggle()
                    }
                }) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isOpened ? 180 : 0))
                        .bold()
                        .foregroundColor(Color.black)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
            
            // 뜻 보기
            VStack{
                if(isOpened){
                    Text(meaning)
                        .font(.title3)
                        .foregroundColor(Color.white)
                }
            }
            .frame(maxWidth:.infinity ,maxHeight: isOpened ? 50 : 0)
            .background(Color.mainColor)
        }
        .frame(width: 310, height: isOpened ? 170 : 120)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color:.lightGray, radius: 20)
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView(word: "school", meaning: "학교")
    }
}
