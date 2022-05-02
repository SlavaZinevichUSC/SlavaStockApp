//
//  StockEmptyPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockEmptyPortfolioView: View {
    @EnvironmentObject var commonData : StockCommonData
    private let item : PortfolioItem
    private let cash : CashItem
    private let cols = [GridItem(.fixed(UIScreen.screenWidth60)), GridItem(.flexible(minimum: 50, maximum: .infinity))]
    var body: some View {
        LazyVGrid(columns: cols, alignment: .leading){
            VStack(alignment: .leading){
                Text("You have 0 shares of \(commonData.id). \n").AsInfo()
                Text("Start trading!").AsInfo()
            }
            StockTradeButton(cash, item)
        }
    }
    
    init(_ cash : CashItem, _ item : PortfolioItem){
        self.item = item
        self.cash = cash
    }
                     
}

extension StockEmptyPortfolioView{
}

struct StockEmptyPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockEmptyPortfolioView(CashItem.Default(), PortfolioItem.Default())
    }
}
