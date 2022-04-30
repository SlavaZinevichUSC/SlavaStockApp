//
//  StockAboutView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import SwiftUI

struct StockAboutView: View {
    @ObservedObject var vm : ViewModel
    private let id : String
    private let columns = [GridItem(), GridItem()]
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 15){
            Text.Bold("IPO Start Date: ").AsInfo()
            AsText(vm.profile.ipo)
            Text.Bold("Industry:").AsInfo()
            AsText(vm.profile.industry)
            Text.Bold("Web Url: ").AsInfo()
            AsLink(vm.profile.webUrl)
        }
        
    }
    
    init(_ id : String, _ container : ServiceContainer){
        self.id = id
        self.vm = ViewModel(id, container.GetHttpService())
    }
    
    
    func AsText(_ value : String) -> Text{
        return Text("\(value)").AsInfo()
    }
    
    func AsLink(_ value : String) -> Text{
        let link = "[\(value)](\(value))"
        return Text(.init(link)).AsInfo()
    }
    
    
}

extension StockAboutView{
    class ViewModel : ObservableObject{
        @Published var profile : ApiProfileDetails
        
        init(_ id : String, _ http : IHttpService){
            profile = ApiProfileDetails.Default()
            http.Get(id: id) { data in
                self.profile = data
            }
        }
    }
}



struct StockAboutView_Previews: PreviewProvider {
    static var previews: some View {
        StockAboutView("AAPL", ServiceContainer.Default())
    }
}
