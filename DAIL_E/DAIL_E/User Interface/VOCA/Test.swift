//
//  Test.swift
//  DAIL_E
//
//  Created by Park on 2023/05/28.
//

import SwiftUI

struct Test: View {
    @State private var gauge:CGFloat = 0        // 게이지 정도
    let gaugeLen:CGFloat = 320                  // 게이지 전체 길이
    @State private var isShow:Bool = false      // 정답 공개
    @State private var b1Clicked:Bool = false   // 1번 버튼
    @State private var b2Clicked:Bool = false   // 2번 버튼
    @State private var b3Clicked:Bool = false   // 3번 버튼
    @State private var b4Clicked:Bool = false   // 4번 버튼
    @State private var isAlert:Bool = false     // 완료 안내창
    @State private var count:CGFloat = 0        // 맞춘 개수
    @Binding var VOCAProgress:CGFloat           // 단어장 하루 진행도
    @EnvironmentObject var wordModel:AppModel
    @State var testWords:[String] = ["", "", "", ""]
    @State var testMeanings:[String] = ["", "", "", ""]
    @State var index:Int = 0
    
    var body: some View {
        ZStack{
            VStack{
                // navigation
                NavigationBar(isDetail: .constant(true), preTitle: "VOCA", curTitle: "Test")
                
                // body
                VStack{
                    // 진행바
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.lightGray)
                            .frame(width: gaugeLen, height: 15)
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.mainColor)
                            .frame(width: gauge, height: 15)
                            .animation(.linear(duration: 0.25), value: gauge)
                    }
                    
                    // 단어
                    TestWord(word: testWords[index])
                        .padding([.top], 20)
                    
                    // 선택지
                    HStack{
                        TestMeaning(meaning: testMeanings[0], answer:wordModel.wordMap[testWords[index]] ?? "", clicked: $b1Clicked, isShow: $isShow, count: $count)
                        TestMeaning(meaning:testMeanings[1], answer:wordModel.wordMap[testWords[index]] ?? "", clicked: $b2Clicked, isShow: $isShow, count: $count)
                    }
                    .padding([.top], 5)
                    HStack{
                        TestMeaning(meaning:testMeanings[2], answer:wordModel.wordMap[testWords[index]] ?? "", clicked: $b3Clicked, isShow: $isShow, count: $count)
                        TestMeaning(meaning:testMeanings[3], answer:wordModel.wordMap[testWords[index]] ?? "", clicked: $b4Clicked, isShow: $isShow, count: $count)
                    }
                    .padding([.top], 5)
                }
                .padding([.top], 80)
                
                // 다음 문제 버튼
                if(isShow){
                    Button(action: {
                        if(isShow){ // 중복 클릭 방지
                            self.isShow = false
                            self.gauge += gaugeLen/10
                            if(gauge >= gaugeLen){
                                // 팝업 창 -> voca로 돌아가기 {
                                self.VOCAProgress = count/10
                                withAnimation(
                                    .interpolatingSpring(
                                        mass: 1,
                                        stiffness: 400,
                                        damping: 20,
                                        initialVelocity: 1
                                    ).delay(0.3)
                                ){
                                    self.isAlert = true
                                }
                            }
                            else{
                                self.b1Clicked = false
                                self.b2Clicked = false
                                self.b3Clicked = false
                                self.b4Clicked = false
                                
                                self.index += 1
                                var tempMeanings:[String] = []
                                
                                tempMeanings.append(wordModel.wordMap[testWords[index]] ?? "");
                                tempMeanings.append(wordModel.wordMap[testWords[(index+2)%10]] ?? "");
                                tempMeanings.append(wordModel.wordMap[testWords[(index+4)%10]] ?? "");
                                tempMeanings.append(wordModel.wordMap[testWords[(index+6)%10]] ?? "");
                                tempMeanings = tempMeanings.shuffled()
                                self.testMeanings = tempMeanings
                            }
                        }
                    }){
                        Custom_Button(content: "다음", witdh: 120, height: 50)
                    }
                    .padding([.top], 45)
                }
            }
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
            .background(.white)
            .navigationBarHidden(true)
            .blur(radius: isAlert ? 4 : 0)
            .onAppear{
                var tempWords:[String] = []
                var tempMeanings:[String] = []
                
                for entry in wordModel.wordMap {
                    tempWords.append(entry.key)
                }
                tempWords = tempWords.shuffled()
                self.testWords = tempWords
                
                tempMeanings.append(wordModel.wordMap[tempWords[0]] ?? "");
                tempMeanings.append(wordModel.wordMap[tempWords[1]] ?? "");
                tempMeanings.append(wordModel.wordMap[tempWords[2]] ?? "");
                tempMeanings.append(wordModel.wordMap[tempWords[3]] ?? "");
                tempMeanings = tempMeanings.shuffled()
                self.testMeanings = tempMeanings
            }
            
            Alert(count: count)
                .opacity(isAlert ? 1 : 0)
                .offset(y:isAlert ? 0 : 20)
        }
    }
}

struct TestWord: View{
    var word:String
    
    var body: some View{
        VStack{
            Spacer()
            
            // 영어 단어
            Text(word)
                .bold()
                .font(.title)
                .padding([.top], 30)
            
            Spacer()
            
            // 소리 버튼
            HStack{
                Image("Sound")
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
        }
        .frame(width: 310, height: 190)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color:.lightGray, radius: 20)
    }
}

struct TestMeaning: View{
    var meaning:String
    var answer:String
    @Binding var clicked:Bool
    @Binding var isShow:Bool
    @Binding var count:CGFloat
    
    var body: some View{
        ZStack{
            Button(action: {
                if(!isShow){    // 중복 클릭 방지
                    self.clicked = true
                    self.isShow = true
                }
                if(meaning == answer){
                    count += 1
                }
            }){
                Text(meaning)
                    .font(.title3)
                    .foregroundColor(.black)
                    .frame(width: 145, height: 90)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color:.lightGray, radius: 20)
                    .padding(5)
            }
            
            // 선택지 선택
            if(clicked){
                ZStack(alignment: .topTrailing){
                    if(meaning != answer){
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.invalidRed, lineWidth: 3)
                            .frame(width: 145, height: 90)
                        Image(systemName: "x.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color.invalidRed)
                            .padding(10)
                    }
                }
            }
            
            // 정답 공개
            if(meaning == answer && isShow){
                ZStack(alignment: .topTrailing){
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.mainColor, lineWidth: 3)
                        .frame(width: 145, height: 90)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.mainColor)
                        .padding(10)
                }
            }
        }
    }
}

struct Alert: View {
    var count:CGFloat
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size:45))
                .foregroundColor(.mainColor)
            
            Spacer()
            
            VStack{
                Text("10문제 중")
                    .padding(1)
                HStack{
                    Text("\(Int(count))문제")
                        .foregroundColor(.mainColor)
                    Text("맞췄어요!")
                }
            }
            .font(.title2)
            
            Spacer()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Custom_Button(content: "확인", witdh: 90, height: 40)
                
            }
            .padding([.top], 15)
        }
        .padding(25)
        .frame(width: 320, height: 255)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 10)
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test(VOCAProgress: .constant(0))
            .environmentObject({ () -> AppModel in
                let wordModel: AppModel = AppModel()
                
                wordModel.initPrompt()
                wordModel.makeWords()
                return wordModel
            }())
    }
}
