//
//  StockSummaryView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/21/22.
//

import SwiftUI
import RxSwift

struct StockSummaryView: View {
    @ObservedObject private var vm : ViewModel
    @EnvironmentObject var commonData : StockCommonData
    private let id : String
    var body: some View {
        HStack(){
            Text("\(vm.profile.id)").font(.footnote).foregroundColor(Color.gray)
            Spacer()
            Image(vm.profile.imgUrl)
        }
        .frame(minHeight: 100)
        .onAppear(perform: {
            vm.
        })
    }
       
    
    init(_ id: String, _ container : ServiceContainer){
        self.id = id
        self.vm = ViewModel(id: id, http: container.GetHttpService())
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
        private let id : String
        private var http : IHttpService
        @Published var profile : ApiProfile
        init(id: String, http : IHttpService){
            self.id = id
            self.http = http
            self.profile = ApiProfile.Default()
            http.Get(id: id, completion: { data in
                self.OnCompletion(profile: data)
            })
        }
        
        func Subscribe(_ obs: Observable<ApiProfile>){
            _ = obs.subscribe{ data in
                self.profile = data
            }
        }
        
        func OnCompletion(profile : ApiProfile){
            self.profile = profile
        }
    }
}

struct StockSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryView("TSLA", ServiceContainer.Current())
    }
}
