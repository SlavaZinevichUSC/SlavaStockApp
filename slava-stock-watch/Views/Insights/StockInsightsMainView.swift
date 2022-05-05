//
//  StockInsightsMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import SwiftUI

struct StockInsightsMainView: View {
    var body: some View {
        VStack{
            StockInsightsView()
            StockTrendsView()
            StockEpsView()
        }
    }
}

struct StockInsightsMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockInsightsMainView()
    }
}
