//
//  VOCA.swift
//  DAIL_E
//
//  Created by Park on 2023/05/28.
//

import SwiftUI

struct VOCA: View {
    @Binding var detailVOCA:Bool
    @Binding var VOCAProgress:CGFloat
    @EnvironmentObject var wordModel:AppModel
    
    var body: some View {
        ZStack{
            NavigationView {
                VStack{
                    // navigation
                    NavigationBar(isDetail: $detailVOCA, preTitle: "Home", curTitle: "VOCA")
                    
                    Spacer()
                    
                    // body{
                    ScrollView{
                        Spacer(minLength: 10)
                        ForEach(wordModel.wordMap.keys.sorted(), id: \.self) { index in
                            WordView(isMarked: dbHelper.searchVoca(word: index), word:index, meaning:wordModel.wordMap[index] ?? "")
                                .padding(EdgeInsets(top: 20, leading: 40, bottom: 0, trailing: 40))
                        }
                        Spacer(minLength: 30)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Spacer()
                    
                    // bottom buttons
                    bottomBar(VOCAProgress: $VOCAProgress)
                }
                .ignoresSafeArea()
                .background(.white)
                .navigationBarHidden(true)
            }
        }
    }
}

struct bottomBar: View {
    @Binding var VOCAProgress:CGFloat
    @EnvironmentObject var wordModel:AppModel
    
    var body: some View {
        HStack{
            // Refresh 버튼
            Button(action: {
                if wordModel.isThinking {
                    // Handle the case when isThinking is true
                } else {
                    wordModel.makeWords()
                }}){
                    VStack{
                        if(wordModel.isThinking) {
                            ProgressView()
                                .frame(width: 27, height: 27)
                        }
                        else {
                            Image("Refresh")
                        }
                        Text("Refresh")
                            .bold()
                            .foregroundColor(Color.midGray)
                    }
                }
                .frame(width: 100)
            
            Spacer()
            
            // Test 버튼
            NavigationLink(destination: Test(VOCAProgress: $VOCAProgress)) {
                VStack{
                    Image("Test")
                    Text("Test")
                        .bold()
                        .foregroundColor(Color.midGray)
                }
                .frame(width: 100)
            }
            
            Spacer()
            
            // Collections 버튼
            NavigationLink(destination: Collections()) {
                VStack{
                    Image("Collections")
                    Text("Collections")
                        .bold()
                        .foregroundColor(Color.midGray)
                }
                .frame(width: 100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .padding([.leading, .trailing], 25)
        .background(Color.white)
        .shadow(color:.lightGray, radius: 20, y:-5)
    }
}

struct VOCA_Previews: PreviewProvider {
    static var previews: some View {
        VOCA(detailVOCA: .constant(true), VOCAProgress: .constant(0))
            .environmentObject({ () -> AppModel in
            let wordModel: AppModel = AppModel()
            
            wordModel.initPrompt()
            wordModel.makeWords()
            return wordModel
        }())
    }
}
