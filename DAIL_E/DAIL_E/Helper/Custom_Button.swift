//
//  Button.swift
//  DAIL_E
//
//  Created by Park on 2023/06/04.
//

import SwiftUI

struct Custom_Button: View {
    var content:String
    var witdh:CGFloat
    var height:CGFloat
    
    var body: some View {
        VStack{
            Text(content)
                .font(.title3)
                .bold()
                .foregroundColor(Color.black)
        }
        .frame(width: witdh, height: height)
        .background(Color.lightGray)
        .cornerRadius(50)
    }
}

struct Custom_Button_Previews: PreviewProvider {
    static var previews: some View {
        Custom_Button(content: "바로가기", witdh: 120, height: 50)
    }
}
