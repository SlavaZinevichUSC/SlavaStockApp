//
//  StockAboutView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import SwiftUI

struct StockAboutView: View {
    @StateObject var vm : SingleItemVM = SingleItemVM<ApiProfileDetails>()
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    
    private let columns = [GridItem(), GridItem()]
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 15){
            Text.Bold("IPO Start Date: ").AsInfo()
            AsText(vm.data.ipo)
            
            Text.Bold("Industry:").AsInfo()
            AsText(vm.data.industry)
            
            Text.Bold("Web Url: ").AsInfo()
            AsLink(vm.data.webUrl)
        }
        .onAppear(perform: {
            vm.Get(commonData.id, container.GetHttpService())
        })
    }
    
    
    
}

extension StockAboutView{
    
    private func AsText(_ value : String) -> Text{
        return Text("\(value)").AsInfo()
    }
    
    private func AsLink(_ value : String) -> Text{
        let link = "[\(value)](\(value))"
        return Text(.init(link)).AsInfo()
    }
}


struct StockAboutView_Previews: PreviewProvider {
    static var previews: some View {
        StockAboutView()
    }
}
