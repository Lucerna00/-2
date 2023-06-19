import SwiftUI

struct DiaryView: View {
    @State private var txt: String = ""
    @Binding var selectedDate: Date?
    @State private var isShowingDiaryChatView = false
    @State private var isShowingPlace = false
    @State private var Place_tosave: String? = nil
    @Binding var isActive: Bool
    @State var diary_info : DiaryInfo = DiaryInfo(date: "", place: "", contents: "", response: "")
    var body: some View {
        VStack{
            NavigationBar(isDetail: .constant(true), preTitle: "DIARY", curTitle: "Input")
            
            VStack(alignment: .center) {
                // 1. 제목 : Let's try write your diary
                VStack{
                    Text("Let's try write your diary!")
                        .font(.title2)
                        .padding(20)
                    
                    // 2. 글상자
                    VStack {
                        // 1. Hstack(Date, Place)
                        HStack {
                            //CalendarView에서 날짜정보 가져옴
                            Text(selectedDate?.formatted(date: .numeric, time: .omitted) ?? "_")
                            Spacer()
                            //AddressView로 주소 정보 입력
                            VStack{
                                Button(action: { self.isShowingPlace.toggle() }) {
                                    Text("Place")
                                }.sheet(isPresented: $isShowingPlace, content: {
                                    AddressView(Place_tosave: $Place_tosave,isShwoingSheet: $isShowingPlace)
                                })
                                Text(Place_tosave ?? "")
                            }
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .frame(height: 70)
                }
                .background(.white)
                .shadow(color:.lightGray, radius: 20, y:-5)
                    
                // 2. Textfield
                TextEditor(text: $txt)
                    .cornerRadius(15)
                    .padding()
            }
            .background(.white)
            .frame(height:530)
            .clipShape(RoundedRectangle(cornerRadius:15))
            .shadow(color:.lightGray, radius: 20)
            .padding(30)
                
            // 3. 제출 버튼
            Button(action: {
                isShowingDiaryChatView = true
                diary_info.date = selectedDate?.formatted(date: .numeric, time: .omitted) ?? "_"
                self.diary_info.place = Place_tosave ?? ""
                self.diary_info.contents = txt
                diary_info.response = ""
                testjson(info: diary_info)
            }){
                Custom_Button(content: "Complete", witdh: 150, height: 55)
            }
            
            
            //NavigationLink로 구현하면 openai api가 텍스트에디터에서 한 글자 칠 때마다 api에 접속해서 한도초과뜸 -> sheet로 변경
            .padding()
            .sheet(isPresented: $isShowingDiaryChatView,
                   onDismiss: {
                //            print("isactive = \(isActive)")
                //            isActive = false
                //            print("isactive = \(isActive)")
                //            HomeView_v2()
                
            }) {
                DiaryChatView(input: txt, date: selectedDate?.formatted(date: .numeric, time: .omitted) ?? "_", place: Place_tosave ?? "" , contents: txt, response: "" )
            }
        }
        .ignoresSafeArea()
        .background(.white)
        .navigationBarHidden(true)
    }
}

struct DiaryView_Previes: PreviewProvider{
    @State static private var isActive: Bool = false
    static var previews: some View {
        DiaryView(selectedDate: .constant(Date()), isActive: $isActive)
    }
}

/* DiaryExample
 Today is my birthday. It was happy,  Because my friends celebrated me passionately. I will give my loves to my friend and family.
 */

