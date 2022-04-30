//
//  StockPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockPortfolioView: View {
    @ObservedObject var vm : ViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    init(_ id : String, _ container : ServiceContainer){
        vm = ViewModel(id, container)
    }
}

extension StockPortfolioView{
    
    private func GetView() -> some View{
        guard vm.item != nil else {
            return GetNewView()
        }
        return GetNewView()
    }
    
    private func GetNewView() -> some View{
        return VStack {
            Text("")
        }
    }
    
    
}

extension StockPortfolioView{
    class ViewModel : ObservableObject{
        let portfolioService : IPortfolioService
        @Published var cash : CashItem
        @Published var item : PortfolioItem?
        init(_ id : String, _ container : ServiceContainer){
            portfolioService = container.GetPortfolioService()
            cash = portfolioService.GetCash()
            item = portfolioService.GetPortfolioFile(id)
            
        }
    }
}

struct StockPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockPortfolioView("AAPL", ServiceContainer.Production())
    }
}
