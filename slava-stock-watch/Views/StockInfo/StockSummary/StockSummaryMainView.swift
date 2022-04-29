//
//  StockSummaryMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import SwiftUI

struct StockSummaryMainView: View {
    private let id : String
    @EnvironmentObject var factory : ServiceFactory

    var body: some View {
        VStack{
            StockSummaryView(id, factory)
            StockSummaryPriceView(id, factory)
        }
    }
    
    init(_ id : String){
        self.id = id
    }
}

struct StockSummaryMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryMainView("AAPL")
    }
}
