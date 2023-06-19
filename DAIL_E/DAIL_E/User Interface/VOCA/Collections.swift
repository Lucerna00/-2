//
//  Collections.swift
//  DAIL_E
//
//  Created by Park on 2023/05/28.
//

import SwiftUI

struct Collections: View {
    @State var vocas:[String:String] = [:]
    
    var body: some View {
        VStack{
            // navigation
            NavigationBar(isDetail: .constant(true), preTitle: "VOCA", curTitle: "Collections")
            
            // body
            ScrollView{
                Spacer(minLength: 10)
                ForEach(vocas.keys.sorted(), id: \.self){ i in
                    WordView(isMarked: true, word:i, meaning:vocas[i] ?? "")
                    .padding(EdgeInsets(top: 20, leading: 40, bottom: 0, trailing: 40))
                }
                Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .frame(maxHeight: .infinity, alignment: .top)
        .background(.white)
        .navigationBarHidden(true)
        .onAppear {
            self.vocas = dbHelper.readVoca()
        }
    }
}

struct Collections_Previews: PreviewProvider {
    static var previews: some View {
        Collections()
    }
}
