//
//  StockPortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

struct StockPortfolioView: View {
    @ObservedObject var vm : ViewModel
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    
    var body: some View {
            if(vm.item.HasShares()){
                StockExistingPortfolioView(vm.item)
            }
            else {
                StockEmptyPortfolioView()
            }
    }
    
    init(_ id : String, _ container : ServiceContainer){
        vm = ViewModel(id, container)
    }
}

extension StockPortfolioView{
    
    private func EmptyPortfolioView() -> AnyView{
        return AnyView(Text("Empty"))
    }
    
    private func ExistingPortfolioView() -> AnyView{
        return AnyView(Text("You have \(vm.item.shares)"))
    }
    
}

extension StockPortfolioView{
    class ViewModel : ObservableObject{
        @Published var item : PortfolioItem
        init(_ id : String, _ container : ServiceContainer){
            item = PortfolioItem.Default()
            _ = container.GetPortfolioDataService().GetPortfolioItemObs(id, "").subscribe{data in
                self.item = data
            }
        }
    }
}

struct StockPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockPortfolioView("AAPL", ServiceContainer.Current())
    }
}
