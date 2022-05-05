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
                MainPortfolioItemView(item, vm.stats[item.id] ?? ApiStats.Default())
            }
        }
        .onAppear(perform: {
            vm.OnAppear(container)
        })
    }
}
extension MainPortfolioView{
    
    private func GetBreakdown() -> some View{
        return HStack(spacing: 10){
            GetBreakDownItem("Net Worth:", vm.cash.money + vm.totalPortfolioValue)
            Spacer()
            GetBreakDownItem("Cash Balance:", vm.cash.money)
        }
    }
    
    private func GetBreakDownItem(_ text : String, _ value : Double) -> some View{
        VStack(alignment: .leading, spacing: 10){
            Text(text).font(.body)
            Text("$\(String.FormatDouble(value))").bold().font(.body)
        }
    }
}
extension MainPortfolioView{
    class ViewModel : ObservableObject{
        @Published var cash : CashItem = CashItem.Default()
        @Published var portfolio : [PortfolioItem] = []
        var stats  : Dictionary<String, ApiStats> = Dictionary()
        var totalPortfolioValue : Double {
            portfolio.reduce(0, { (val, item) in
                return val + Double(item.shares) * (stats[item.id]?.current ?? 0)
            })
        }
        
        func  OnAppear(_ container : ServiceContainer){
            let portfolio = container.GetPortfolioDataService()
            _ = portfolio.GetCashObs().subscribe{ cashItem in
                self.cash = cashItem
            }
            _ = portfolio.GetFullPortfolioObs().subscribe{
                self.ConstructPortfolio($0, container)
            }
            
        }
        
        private func ConstructPortfolio(_ portfolio : [PortfolioItem], _ container : ServiceContainer){
            self.portfolio = portfolio
            for item in portfolio{
                _ = container.GetHttpService().Get(id: item.id).subscribe{(data : ApiStats) in
                    self.stats[item.id] = data
                    self.portfolio = portfolio
                }
            }
        }
    }
}

struct MainPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        MainPortfolioView()
    }
}
