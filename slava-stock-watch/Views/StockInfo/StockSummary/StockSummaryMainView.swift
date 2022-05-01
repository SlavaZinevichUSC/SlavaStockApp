//
//  StockSummaryMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import SwiftUI

struct StockSummaryMainView: View {

    var body: some View {
        VStack{
            StockSummaryView()
            StockSummaryPriceView()
        }
    }
    
}

struct StockSummaryMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryMainView()
    }
}
