//  CalendarView.swift
//  chatgpt_v2
//
//  Created by 신영재 on 2023/05/17.
//
// CalendarView.swift

import SwiftUI
struct CalendarView: View {
    @Binding var detailDIARY:Bool
    @Binding var DIARYProgress:CGFloat
    @State private var selectedDate: Date? = nil
    @State private var showDiaryView = false
    @State private var isActive: Bool = false
    var body: some View {
        NavigationView{
            VStack {
                NavigationBar(isDetail: $detailDIARY, preTitle: "Home", curTitle: "DIARY")
                
                Spacer()
                
                CalendarModuleView(selectedDate: $selectedDate)
                    .padding()
                    .background(.white)
                    .frame(height:330)
                    .clipShape(RoundedRectangle(cornerRadius:15))
                    .shadow(color:.lightGray, radius: 20)
                    .padding(30)
                
                Spacer()
                
                NavigationLink(destination: DiaryView(selectedDate: $selectedDate, isActive: $isActive)){
                    Custom_Button(content: "Write", witdh: 120, height: 55)
                }
                
                Spacer()
            }
            .ignoresSafeArea()
            .background(.white)
            .navigationBarHidden(true)
        }
    }
}

struct CalendarView_Previes: PreviewProvider{
    static var previews: some View {
        CalendarView(detailDIARY: .constant(true), DIARYProgress: .constant(0))
    }
}
