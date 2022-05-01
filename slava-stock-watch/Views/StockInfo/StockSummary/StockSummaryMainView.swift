//
//  StockSummaryMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import SwiftUI

struct StockSummaryMainView: View {
    private let id : String
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData

    var body: some View {
        VStack{
            StockSummaryView(id, container)
            StockSummaryPriceView()
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
