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
    @State var showTrade = false

    var body: some View {
        Button(action: {
            print("Pressed")
            self.showTrade.toggle()
            
        }, label: {
            Text("Trade")
                .frame(width: UIScreen.dScreenWidth25, height : 50)
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(10)
        })
        .sheet(isPresented: $showTrade){
            StockTradeView(cash, $showTrade)
        }
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
