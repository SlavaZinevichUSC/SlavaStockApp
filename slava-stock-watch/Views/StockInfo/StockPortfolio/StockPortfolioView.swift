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
        Group{
                if(vm.item.HasShares()){
                    StockExistingPortfolioView(vm.item)
                }
                else {
                    StockEmptyPortfolioView()
                }
        }.onAppear(perform: {
            vm.Activate(commonData, container)
        })
    }
    
    init(_ commonData : StockCommonData, _ container : ServiceContainer){
        vm = ViewModel(commonData, container)
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
        init(_ commonData : StockCommonData, _ container : ServiceContainer){
            item = PortfolioItem.Default()
            Activate(commonData, container)
        }
        
        func Activate(_ commonData : StockCommonData, _ container : ServiceContainer){
            _ = container.GetPortfolioDataService().GetPortfolioItemObs(commonData.id, commonData.name).subscribe{data in
                self.item = data
            }
        }
    }
}

struct StockPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        StockPortfolioView(StockCommonData.Empty(), ServiceContainer.Current())
    }
}
