//
//  Home.swift
//  DAIL_E
//
//  Created by Park on 2023/05/28.
//

import SwiftUI

let dbHelper = DBHelper.shared

struct Home: View {
    @State var detailVOCA:Bool = false
    @State var detailCHAT:Bool = false
    @State var detailTOEIC:Bool = false
    @State var detailDIARY:Bool = false
    @State var VOCAProgress:CGFloat = 0
    @State var TOEICProgress:CGFloat = 0
    @State var CHATProgress:CGFloat = 0
    @State var DIARYProgress:CGFloat = 0
    let wordModel: AppModel = AppModel()
    
    init(){
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.lightGray)
        
        // 앱 시작 시 단어 받아오기
        self.wordModel.initPrompt()
        self.wordModel.makeWords()
    }
    
    var body: some View {
        ZStack{
            VStack{
                ZStack(alignment: .top){
                    // 배경
                    Rectangle()
                        .fill(Color.mainColor)
                        .frame(height: 290)
                        .cornerRadius(70, corners: .bottomLeft)
                        .cornerRadius(70, corners: .bottomRight)
                        .ignoresSafeArea()
                        .offset(y:(detailVOCA || detailCHAT || detailTOEIC || detailDIARY) ? -210:0)
                    
                    // 로고
                    Image("Logo")
                        .padding(20)
                    
                    // 배너
                    TabView {
                        ForEach(0..<4){ i in
                            banner(index: i)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 320)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .offset(y:65)
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .ignoresSafeArea()
                
                VStack{
                    HStack{
                        // VOCA 버튼
                        Button(action: {
                            if(!detailVOCA){
                                withAnimation(.easeInOut(duration: 0.2)){
                                    self.detailVOCA = true
                                }
                            }
                        }){
                            content(imageName: "VOCA", title: "VOCA", completionAmount: $VOCAProgress)
                        }
                        
                        // TOEIC 버튼
                        Button(action: {
                            if(!detailTOEIC){
                                withAnimation(.easeInOut(duration: 0.2)){
                                    self.detailTOEIC = true
                                }
                            }
                        }){
                            content(imageName: "TOEIC", title: "TOEIC", completionAmount: $TOEICProgress)
                        }
                    }
                    HStack{
                        Button(action: {
                            if(!detailCHAT){
                                withAnimation(.easeInOut(duration: 0.2)){
                                    self.detailCHAT = true
                                }
                            }
                        }){
                            content(imageName: "CHAT", title: "CHAT", completionAmount: $CHATProgress)
                        }
                        Button(action: {
                            if(!detailDIARY){
                                withAnimation(.easeInOut(duration: 0.2)){
                                    self.detailDIARY = true
                                }
                            }
                        }){
                            content(imageName: "DIARY", title: "DIARY", completionAmount: $DIARYProgress)
                        }
                    }
                    Spacer()
                }
            }
            .background(.white)
            .opacity((detailVOCA || detailCHAT || detailTOEIC || detailDIARY) ? 0.6:1)
            
            // VOCA 창 전환
            if(detailVOCA){
                VOCA(detailVOCA: $detailVOCA, VOCAProgress: $VOCAProgress)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1).delay(0.2)))
                    .environmentObject(wordModel)
            }
            
            // TOEIC 창 전환
            else if(detailTOEIC){
                ToeicView(detailTOEIC: $detailTOEIC, TOEICProgress: $TOEICProgress)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1).delay(0.2)))
            }
            
            // CHAT 창 전환
            else if(detailCHAT){
                ChatView(detailCHAT: $detailCHAT, CHATProgress: $CHATProgress)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1).delay(0.2)))
            }
            
            // DIARY 창 전환
            else if(detailDIARY){
                CalendarView(detailDIARY: $detailDIARY, DIARYProgress: $DIARYProgress)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.1).delay(0.2)))
            }
        }
    }
}

struct banner: View{
    let bannerTitle:[String] = ["나만의 단어장", "토익 풀이", "회화", "일기장"]
    let bannerContent:[String] = ["매일 Chat GPT가 추전해주는\n10개의 단어를 외워보세요!",
                                  "매일 Chat GPT가 추전해주는\n새로운 토익 문제를 풀어보세요!",
                                  "Chat GPT와 소통하며\n회화 능력을 키워보세요!",
                                  "매일 영어 일기장을 작성하고\n코멘트를 받아보세요!"]
    let lineLengh:[CGFloat] = [180, 120, 70, 90]
    var index:Int
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: lineLengh[index], height: 25)
                    .offset(y:5)
                Text(bannerTitle[index])
                    .font(.title)
                    .bold()
            }
            Text(bannerContent[index])
                .multilineTextAlignment(.center)
                .frame(height: 50)
            Button(action: {}){
                Custom_Button(content: "바로가기", witdh: 120, height: 40)
            }
            .padding([.top], 10)
        }
        .frame(width: 320, height: 215)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 10)
    }
}

struct content: View {
    let imageName:String
    let title:String
    @Binding var completionAmount:CGFloat
    
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .fill(Color.lightGray)
                    .frame(width:140, height: 140)
                Circle()
                    .trim(from: 0, to: completionAmount)
                    .stroke(Color.mainColor, lineWidth: 5)
                    .frame(width:135, height: 135)
                    .rotationEffect(.degrees(-90))
                Circle()
                    .fill(Color.white)
                    .frame(width:130, height: 130)
                Image(imageName)
                    .resizable()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                Circle()
                    .fill(Color.black)
                    .frame(width:110, height: 110)
                    .opacity(0.4)
                Text("\(Int(completionAmount*100))%")
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color.white)
            }
            Text(title)
                .font(.title3)
                .bold()
                .foregroundColor(Color.mainColor)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
