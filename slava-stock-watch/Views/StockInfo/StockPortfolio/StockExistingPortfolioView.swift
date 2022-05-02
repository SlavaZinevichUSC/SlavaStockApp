//
//  StockExistingPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockExistingPortfolioView: View {
    @EnvironmentObject var container : ServiceContainer
    @ObservedObject var vm : ViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 15){
            VStack{
                Text("Shares Owned:   ").bold().Normal("\(vm.stock.shares)")
            }
            Text("Filler")
        }
        .onAppear(perform: {
            vm.Activate(container)
        })
    }
    
    init(_ id : String){
        vm = ViewModel(id)
    }
}

extension StockExistingPortfolioView{
    class ViewModel : ObservableObject{
        let id : String
        @Published var stock : PortfolioItem = PortfolioItem.Default()
        @Published var cash : CashItem = CashItem.Default()
        init(_ id : String){
            self.id = id
        }
        
        func Activate(_ container : ServiceContainer){
            let portfolio = container.GetPortfolioDataService()
            
            _ = portfolio.GetPortfolioItemObs(id, "").subscribe{data in
                self.stock = data
            }
            _ = portfolio.GetCashObs().subscribe{ data in
                self.cash = data
            }
        }
    }
}

struct StockExistingPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockExistingPortfolioView("AAPL")
    }
}
