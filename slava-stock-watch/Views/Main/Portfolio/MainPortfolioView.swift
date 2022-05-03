//
//  MainPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/2/22.
//

import SwiftUI

struct MainPortfolioView: View {
    @EnvironmentObject var container : ServiceContainer
    @StateObject var vm : ViewModel = ViewModel()
    var body: some View {
        Section("portfolio"){
            GetBreakdown()
            ForEach(vm.portfolio, id: \.id){item in
                MainPortfolioItemView(item)
            }
        }
        .onAppear(perform: {
            vm.OnAppear(container)
        })
    }
}
extension MainPortfolioView{
    
    private func GetBreakdown() -> some View{
        return HStack(spacing: 30){
            GetBreakDownItem("Net Worth:", vm.cash.money + vm.totalPortfolioValue)
            GetBreakDownItem("Cash Balance:", vm.cash.money)
        }
    }
    
    private func GetBreakDownItem(_ text : String, _ value : Double) -> some View{
        VStack(alignment: .leading, spacing: 10){
            Text(text).font(.body)
            Text("$\(String.FormatDouble(value))").bold().font(.body)
        }
        .frame(minWidth: UIScreen.dScreenWidth50)
    }
}
extension MainPortfolioView{
    class ViewModel : ObservableObject{
        @Published var cash : CashItem = CashItem.Default()
        @Published var portfolio : [PortfolioItem] = []
        @Published var totalPortfolioValue : Double = 0
        
        func  OnAppear(_ container : ServiceContainer){
            let portfolio = container.GetPortfolioDataService()
            _ = portfolio.GetCashObs().subscribe{ cashItem in
                self.cash = cashItem
            }
            _ = portfolio.GetFullPortfolioObs().subscribe{
                self.ConstructPortfolio($0)
            }
        }
        
        private func ConstructPortfolio(_ portfolio : [PortfolioItem]){
            self.portfolio = portfolio
            totalPortfolioValue = portfolio.reduce(0,{ (tot, item) in
                return tot + item.totalCost
            })
        }
    }
}

struct MainPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        MainPortfolioView()
    }
}
