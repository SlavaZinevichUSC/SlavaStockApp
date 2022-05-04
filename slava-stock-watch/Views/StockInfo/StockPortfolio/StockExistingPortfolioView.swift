//
//  StockExistingPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockExistingPortfolioView: View {
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    @ObservedObject var vm : ViewModel
    private let cols = [GridItem(.fixed(UIScreen.screenWidth60)), GridItem()]
    
    var body: some View {
        LazyVGrid(columns: cols, alignment: .leading, spacing: 15){
            VStack(alignment: .leading){
                Text.Bold("Shares Owned:  ").Normal("\(vm.stock.shares)").padding(.bottom)
                Text.Bold("Avg cost / share:  ").Normal("\(vm.stock.avgPrice)").padding(.bottom)
                Text.Bold("Total Cost:  ").Double(vm.stock.totalCost).padding(.bottom)
                (Text.Bold("Change:  ") + Text.FormatChange(vm.GetChange(commonData))).padding(.bottom)
                Text.Bold("Market Value:  ") + Text.FormatRelative(vm.stock.totalCost, vm.GetCurrentTotal(commonData))
            }
            StockTradeButton()
        }
        .onAppear(perform: {
            vm.Activate(container)
        })
    }
    
    init(_ stock : PortfolioItem){
        vm = ViewModel(stock)
    }
}

extension StockExistingPortfolioView{
}

extension StockExistingPortfolioView{
    class ViewModel : ObservableObject{
        @Published var stock : PortfolioItem
        @Published var cash : CashItem = CashItem.Default()
        init(_ stock : PortfolioItem){
            self.stock = stock
        }
        
        func Activate(_ container : ServiceContainer){
            let portfolio = container.GetPortfolioDataService()
            
            _ = portfolio.GetPortfolioItemObs(stock.id, "").subscribe{data in
                self.stock = data
            }
            _ = portfolio.GetCashObs().subscribe{ data in
                self.cash = data
            }
        }
        
        func GetChange(_ commonData : StockCommonData) -> Double{
            return stock.avgPrice - commonData.stats.value.current
        }
        
        func GetCurrentTotal(_ commonData : StockCommonData) -> Double {
            return commonData.stats.value.current * Double(self.stock.shares)
        }
    }
}

struct StockExistingPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockExistingPortfolioView(PortfolioItem.Default())
    }
}
