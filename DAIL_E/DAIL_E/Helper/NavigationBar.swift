//
//  NavigationBar.swift
//  DAIL_E
//
//  Created by Park on 2023/06/04.
//

import SwiftUI


struct NavigationBar: View{
    @Binding var isDetail:Bool
    var preTitle:String
    var curTitle:String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        ZStack{
            // 배경
            Rectangle()
                .fill(Color.mainColor)
                .shadow(color:.lightGray, radius: 20, y:5)
            
            // 뒤로가기 버튼
            VStack{
                Button(action: {
                    withAnimation{
                        self.isDetail = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }){
                    HStack{
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundColor(Color.white)
                        Text(preTitle)
                            .font(.title2)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 0))
                }
            }
            
            // 현재 화면 제목
            Text(curTitle)
                .font(.title2)
                .foregroundColor(Color.white)
                .padding([.top], 50)
        }
        .frame(height: 120)
    }
}


struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(isDetail: .constant(true), preTitle: "Home", curTitle: "VOCA")
    }
}
