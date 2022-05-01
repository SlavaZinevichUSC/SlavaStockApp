//
//  StockTradeButton.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockTradeButton: View {
    private let cash : CashItem
    private let item : PortfolioItem
    
    var body: some View {
        Button(action: {print("Pressed")}, label: {
            Text("Trade")
                .foregroundColor(.white)
                .frame(width: UIScreen.dScreenWidth25, height : 50)
                .background(.green)
                .cornerRadius(10)
        })
    }
    
    
    init(_ cash : CashItem, _ item : PortfolioItem){
        self.cash = cash
        self.item = item
    }
}

extension StockTradeButton{
    class ViewModel : ObservableObject{
        private let cash : CashItem
        private let item : PortfolioItem
        
        init(_ cash : CashItem, _ item : PortfolioItem){
            self.cash = cash
            self.item = item
        }
    }
}

struct StockTradeButton_Previews: PreviewProvider {
    static var previews: some View {
        StockTradeButton(CashItem.Default(), PortfolioItem.Default())
    }
}
