//
//  MainPortfolioItemView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import SwiftUI

struct MainPortfolioItemView: View {
    @ObservedObject var vm : ViewModel
    @EnvironmentObject var container : ServiceContainer
    var body: some View {
        NavigationLink(destination: StockMainView(vm.searchItem)){
            
            HStack(spacing: 2){
                VStack{
                    Text.Bold(vm.displayItem.item.id)
                    Text("\(vm.displayItem.item.shares) shares").font(.caption)
                }.padding(.horizontal, 40)
                GetArrow()
                VStack{
                    Text.Bold("$\(vm.displayItem.item.totalCost.Format())")
                    Text("$\(vm.displayItem.change.Format()) (\(vm.displayItem.changePercent.Format())%)").WithChangeColor(vm.displayItem.change)
                }
            }
        }
    }
    
    init(_ item : PortfolioItem, _ stats : ApiStats){
        vm = ViewModel(item, stats)
    }
}

extension MainPortfolioItemView{
    func GetArrow() -> some View {
        let isUp = vm.displayItem.change > 0
        let arrow = isUp ? "arrow.up.right" : "arrow.down.right"
        return Image(systemName: arrow).foregroundColor(isUp ? Color.green : Color.red)
    }
}

extension MainPortfolioItemView{
    class ViewModel : ObservableObject{
        private let item : PortfolioItem
        var searchItem : ApiSearchItem {
            return ApiSearchItem(item.id, item.name)
        }
        @Published var displayItem : DisplayItem
        init(_ item : PortfolioItem, _ stats: ApiStats){
            self.item = item
            self.displayItem = DisplayItem(item, stats.current)
        }
    }
}

extension MainPortfolioItemView{
    struct DisplayItem{
        let item : PortfolioItem
        let current : Double
        var change : Double{
            return current - item.avgPrice
        }
        var changePercent : Double {
            return change / item.avgPrice
        }
        
        init(_ item : PortfolioItem, _ current : Double){
            self.item = item
            self.current = current
        }
    }
}

struct MainPortfolioItemView_Previews: PreviewProvider {
    static var previews: some View {
        MainPortfolioItemView(PortfolioItem.Default(), ApiStats.Default())
    }
}
