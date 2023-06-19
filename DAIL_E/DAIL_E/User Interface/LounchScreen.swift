//
//  LounchScreen.swift
//  chatgpt_v2
//
//  Created by Sherzod Makhmudov on 2023/04/25.
//

import SwiftUI

struct LounchScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
            if isActive {
                Home()
            } else {
                VStack {
                    VStack {
                        Image("Lounch")
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
}

struct LounchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LounchScreenView()
    }
}
