//
//  AddressView.swift
//  chatgpt_v2
//
//  Created by 신영재 on 2023/06/10.
//

import MapKit
import SwiftUI

struct AddressRow: View {
    
    let address: AddressResult
    @Binding var Place_toSave: String?
    @Binding var isShowingPlace: Bool
    var body: some View {
        Button(address.title, action: {Place_toSave = address.title; isShowingPlace = false})
    }
    
}
        
//        NavigationLink {
////            MapView(address: address)
//
//        } label: {
//            VStack(alignment: .leading) {
//                Text(address.title)
//                Text(address.subtitle)
//                    .font(.caption)
//            }
//        }
//        .padding(.bottom, 2)
//    }
//}
//struct MapView: View {
//
//    @StateObject private var viewModel = MapViewModel()
//
//    private let address: AddressResult
//
//    init(address: AddressResult) {
//        self.address = address
//    }
//
//    var body: some View {
//        Map(
//            coordinateRegion: $viewModel.region,
//            annotationItems: viewModel.annotationItems,
//            annotationContent: { item in
//                MapMarker(coordinate: item.coordinate)
//            }
//        )
//        .onAppear {
//            self.viewModel.getPlace(from: address)
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
struct ClearButton: View {
    
    @Binding var text: String
    
    var body: some View {
        if text.isEmpty == false {
            HStack {
                Spacer()
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                }
                .foregroundColor(.secondary)
            }
        } else {
            EmptyView()
        }
    }
}

//MAin View
struct AddressView: View {
    
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    @FocusState private var isFocusedTextField: Bool
    @Binding var Place_tosave: String?
    @Binding var isShwoingSheet: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {

                TextField("Type address", text: $viewModel.searchableText)
                    .padding()
                    .autocorrectionDisabled()
                    .focused($isFocusedTextField)
                    .font(.title)
                    .onReceive(
                        viewModel.$searchableText.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        viewModel.searchAddress($0)
                    }
                    .background(Color.init(uiColor: .systemBackground))
                    .overlay {
                        ClearButton(text: $viewModel.searchableText)
                            .padding(.trailing)
                            .padding(.top, 8)
                    }
                    .onAppear {
                        isFocusedTextField = true
                    }

                List(self.viewModel.results) { address in
                    AddressRow(address: address, Place_toSave: $Place_tosave,isShowingPlace: $isShwoingSheet)
                        .listRowBackground(backgroundColor)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(backgroundColor)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    var backgroundColor: Color = Color.init(uiColor: .systemGray6)
}


struct AddressView_Previews: PreviewProvider {
    static var previews: some View {

        AddressView(Place_tosave: .constant(""), isShwoingSheet: .constant(true))

    }

}
