//
//  StockSummaryView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/21/22.
//

import SwiftUI

struct StockSummaryView: View {
    private let vm : ViewModel
    private let id : String
    @EnvironmentObject var factory : ServiceFactory
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
       

    
    
    init(_ id: String, factory : ServiceFactory){
        self.id = id
        self.vm = ViewModel(id: id, http: factory.GetHttpService())
    }
    
}

extension StockSummaryView{
    class ViewModel{
        private let id : String
        private var http : IHttpService
        init(id: String, http : IHttpService){
            self.id = id
            self.http = http
        }
        
    }
}

struct StockSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryView("TSLA", factory: ServiceFactory())
    }
}
