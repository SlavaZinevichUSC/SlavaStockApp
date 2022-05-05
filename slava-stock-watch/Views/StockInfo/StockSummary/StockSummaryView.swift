//
//  StockSummaryView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/21/22.
//

import SwiftUI
import RxSwift

struct StockSummaryView: View {
    @ObservedObject private var vm : ViewModel = ViewModel()
    @EnvironmentObject var commonData : StockCommonData
    var body: some View {
        HStack(){
            Text("\(vm.profile.id)").font(.title).foregroundColor(Color.gray).font(.caption).padding()
            Spacer()
            Image(vm.profile.imgUrl).padding()
        }
        .offset(x: -50) //DIRTY DIRTY
        .frame(minHeight: 100)
        .onAppear(perform: {
            vm.Subscribe(commonData.profile.observable)
        })
    }
}

extension StockSummaryView{
    func Image(_ url : String) -> some View{
        AsyncImage(url: URL(string: vm.profile.imgUrl)){image in
            image.resizable().aspectRatio(contentMode: .fill)
        } placeholder: {
            Color.gray
        }
            .frame(width: 50, height: 50, alignment: .leading)
    }
}

extension StockSummaryView{
    class ViewModel : ObservableObject{
        @Published var profile : ApiProfile = ApiProfile.Default()
        
        func Subscribe(_ obs: Observable<ApiProfile>){
            _ = obs.subscribe{ data in
                self.profile = data
            }
        }
    }
}

struct StockSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryView()
    }
}
