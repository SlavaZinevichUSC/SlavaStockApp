//
//  StockTransitionView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/5/22.
//

import SwiftUI

struct StockTransitionView: View {
    @ObservedObject var vm : ViewModel
    @EnvironmentObject var container : ServiceContainer
    var body: some View {
        StockMainView(ApiSearchItem(vm.profile.id, vm.profile.name))
            .onAppear(perform: {
                vm.OnAppear(container)
            })
            
    }
    
    init(_ id : String){
        vm = ViewModel(id)
    }
    
}

extension StockTransitionView{
    class ViewModel : ObservableObject{
        @Published var profile : ApiProfile = ApiProfile.Default()
        private let id : String
        
        init(_ id : String){
            self.id = id
        }
        
        func OnAppear(_ container :ServiceContainer){
            _ = container.GetHttpService().Get(id: self.id).subscribe{data in
                self.profile = data
            }
        }
    }
}

struct StockTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        StockTransitionView("AAPL")
    }
}
