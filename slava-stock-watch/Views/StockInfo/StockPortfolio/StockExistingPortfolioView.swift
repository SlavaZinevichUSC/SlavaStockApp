//
//  StockExistingPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockExistingPortfolioView: View {
    private let cash : CashItem
    private let stock : PortfolioItem
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 15){
            VStack{
                Text("Shares Owned:   ").bold().Normal("\(stock.shares)")
            }
            Text("Filler")
            
        }
    }
    
    init(_ cash : CashItem, _ stock : PortfolioItem){
        self.cash = cash
        self.stock = stock
    }
}

struct StockExistingPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockExistingPortfolioView(CashItem.Default(), PortfolioItem.Default())
    }
}
