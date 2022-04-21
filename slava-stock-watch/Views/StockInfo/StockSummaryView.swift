//
//  StockSummaryView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/21/22.
//

import SwiftUI

struct StockSummaryView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    init(_ id: String){
        
    }
}

extension StockSummaryView{
    class ViewModel{
        private let id : String
        private var http : IHttpService? = nil
        init(_ id: String){
            self.id = id
        }
        
        func OnAppear(_ http : IHttpService){
            let api : ApiProfile = http.Get(id: self.id)
        }
        
    }
}

struct StockSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryView("TSLA")
    }
}
