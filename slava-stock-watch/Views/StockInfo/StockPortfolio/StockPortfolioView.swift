//
//  StockPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockPortfolioView: View {
    @ObservedObject var vm : ViewModel
    @State var containedView : AnyView = AnyView(EmptyView())
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 15){
            containedView
        }
    }
    
    init(_ id : String, _ container : ServiceContainer){
        vm = ViewModel(id, container)
        if(vm.item.HasShares()){
            containedView = ExistingPortfolioView()
        }
        else {
            containedView = EmptyPortfolioView()
        }
    }
}

extension StockPortfolioView{
    
    private func GetView() -> some View{
        return LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 15){
            
            
        }
    }
    
    private func EmptyPortfolioView() -> AnyView{
        return AnyView(Text("Empty"))
    }
    
    private func ExistingPortfolioView() -> AnyView{
        return AnyView(Text("You have \(vm.item.shares)"))
    }
    
}

extension StockPortfolioView{
    class ViewModel : ObservableObject{
        let portfolioService : IPortfolioService
        @Published var cash : CashItem
        @Published var item : PortfolioItem
        init(_ id : String, _ container : ServiceContainer){
            portfolioService = container.GetPortfolioService()
            cash = portfolioService.GetCash()
            item = portfolioService.GetPortfolioFile(id) ?? PortfolioItem.Default()
            
        }
    }
}

struct StockPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockPortfolioView("AAPL", ServiceContainer.Current())
    }
}
