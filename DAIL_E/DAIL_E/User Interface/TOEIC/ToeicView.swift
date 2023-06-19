//
//  ContentView.swift
//  chatgpt_v2
//
//  Created by Sherzod Makhmudov on 2023/04/23.
//

import SwiftUI

struct ToeicView: View {
    @State private var gauge:CGFloat = 0        // 게이지 정도
    let gaugeLen:CGFloat = 320                  // 게이지 전체 길이
    @ObservedObject var model = ToeicModel()
    @State private var selectedButton: Int?
    @State var iscorrect: Bool = false
    @State var isShowing: Bool = false
    @State private var isAlert:Bool = false
    @State var status: [String: Int] = ["correct": 0, "wrong" : 0, "count":1, "num" : 5]
    @Binding var detailTOEIC:Bool
    @Binding var TOEICProgress:CGFloat
    @State var count:CGFloat = 0
    
    var body: some View {
        ZStack{
            Text("Making the Quesition...")
                .opacity(model.isThinking ? 1 : 0)
                .font(.title)
            ZStack{
                VStack {
                    NavigationBar(isDetail: $detailTOEIC, preTitle: "Home", curTitle: "TOEIC")
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.lightGray)
                            .frame(width: gaugeLen, height: 15)
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color.mainColor)
                            .frame(width: gauge, height: 15)
                            .animation(.linear(duration: 0.25), value: gauge)
                    }
                    .padding([.top], 30)
                    
                    VStack{
                        HStack{
                            //question : Give me a short TOEIC multiple choice question
                            Text(model.wordMap["question", default: ""])
                                .bold()
                                .font(.title)
                            Spacer()
                        }
                        Spacer()
                        HStack{
                            VStack(alignment: .leading){
                                Text("")
                                Text(model.wordMap["a", default: ""])
                                Text(model.wordMap["b", default: ""])
                                Text(model.wordMap["c", default: ""])
                                Text(model.wordMap["d", default: ""])
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.white)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius:15))
                    .shadow(color:.lightGray, radius: 20)
                    .padding(30)
                    
                    HStack{
                        ToEic_Button(spelling: "A", index : 1, answer: model.wordMap["result", default: ""], selectedButton : $selectedButton,
                                     correct: $iscorrect, isShowing: $isShowing, status: $status, isAlert: $isAlert, count: $count)
                        ToEic_Button(spelling: "B", index : 2,answer: model.wordMap["result", default: ""],  selectedButton : $selectedButton,
                                     correct: $iscorrect, isShowing: $isShowing, status: $status, isAlert: $isAlert, count: $count)
                    }
                    .padding([.leading, .trailing], 20)
                    HStack{
                        ToEic_Button(spelling: "C", index : 3,answer: model.wordMap["result", default: ""],  selectedButton : $selectedButton,
                                     correct: $iscorrect, isShowing: $isShowing, status: $status, isAlert: $isAlert, count: $count)
                        ToEic_Button(spelling: "D", index : 4, answer: model.wordMap["result", default: ""],  selectedButton : $selectedButton,
                                     correct: $iscorrect, isShowing: $isShowing, status: $status, isAlert: $isAlert, count: $count)
                    }
                    
                    continue_Button(selectedButton: $selectedButton, model: model,isShowing: $isShowing, status:$status, isAlert: $isAlert, gague: $gauge, count: $count, TOEICProgress:$TOEICProgress)
                        .padding(20)
                    
                }
                .background(.white)
                .blur(radius: isAlert ? 4 : 0)
                
                toeicAlert(count: count, detailTOEIC: $detailTOEIC)
                    .opacity(isAlert ? 1 : 0)
                    .offset(y:isAlert ? 0 : 20)
            }
            .opacity(model.isThinking ? 0 : 1)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .background(.white)
    }
}

struct ToEic_Button: View{
    var spelling : String
    var index: Int
    var answer: String
    @Binding var selectedButton: Int?
    @Binding var correct: Bool
    @Binding var isShowing: Bool
    @Binding var status: [String: Int]
    @Binding var isAlert: Bool
    @Binding var count:CGFloat
    
    var body : some View{
        ZStack
        {
            Button(action: {
                //send to gpt "A" or "B" or "C" or "D"
                //클릭하면 색갈 바뀌고, 다시 클릭하면 원상태로 돌아옴.
                if selectedButton == nil {
                    selectedButton = index
                    isShowing = true
                    //정답을 맞췄을 때
                    if(spelling == answer){
                        correct = true
                        status["correct"]! += 1
                        count += 1
                    }
                    else{
                        correct = false
                        status["wrong"]! += 1
                    }
                }
                
            })
            {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color:.lightGray, radius: 20)
                    .frame(width: 160, height: 60)
                    .overlay(
                        Text(spelling)
                            .bold()
                            .font(.title)
                    )
                    .padding(3)
            }.buttonStyle(PlainButtonStyle())
            
            if(isShowing && answer == spelling)
            {
                ZStack(alignment: .topTrailing){
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: 160, height: 60)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.green)
                        .padding(10)
                }
            }
            
        }
        
    }
}

struct continue_Button : View{
    @Binding var selectedButton: Int?
    @ObservedObject var model: ToeicModel
    @Binding var isShowing: Bool
    @Binding var status: [String: Int]
    @Binding var isAlert: Bool
    @Binding var gague:CGFloat
    @Binding var count:CGFloat
    @Binding var TOEICProgress:CGFloat
    
    var body: some View{
        Button {
            status["count"]! += 1
            if (status["count"]! > status["num"]!)
            {
                TOEICProgress = count/5
                isAlert = true
            }
            else
            {
                if model.isThinking {
                    // Handle the case when isThinking is true
                    if(selectedButton == 1 && model.wordMap["result", default: ""] == "A"){
                        print("A true")
                    }else if(selectedButton == 2 && model.wordMap["result", default: ""] == "B"){
                        print("B true")
                    }else if(selectedButton == 3 && model.wordMap["result", default: ""] == "C"){
                        print("C true")
                    }else if(selectedButton == 4 && model.wordMap["result", default: ""] == "D"){
                        print("D true")
                    }
                } else {
                    model.makeWords()
                }
            }
            //question again to gpt
            //Give me a short TOEIC multiple choice question
            selectedButton = nil
            isShowing = false
            gague += 64
        } label :{
            Capsule()
                .fill(Color.lightGray) // Change the fill color based on selectedButton
                .frame(width: 250, height: 70)
                .overlay(
                    Text("Continue")
                        .bold()
                        .font(.title)
                        .foregroundColor(selectedButton != nil ? .black : .white)
                )
        }
        .disabled(selectedButton == nil)
        .opacity(selectedButton == nil ? 0.5 : 1.0)
        .onAppear {
            model.initPrompt()
            model.makeWords()
        }
    }
}

struct toeicAlert: View {
    var count:CGFloat
    @Binding var detailTOEIC:Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size:45))
                .foregroundColor(.mainColor)
            
            Spacer()
            
            VStack{
                Text("5문제 중")
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
                self.detailTOEIC = false
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


struct ToeicView_Previews: PreviewProvider {
    static var previews: some View {
        ToeicView(detailTOEIC: .constant(true), TOEICProgress: .constant(0))
    }
}
