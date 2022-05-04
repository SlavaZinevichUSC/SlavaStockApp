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
        HStack(spacing: 25){
            VStack{
                Text.Bold(vm.displayItem.item.id)
                Text("\(vm.displayItem.item.shares) shares").font(.caption)
            }.padding(.horizontal, 40)
            VStack{
                Text.Bold("$\(vm.displayItem.item.totalCost.Format())")
                Text("$\(vm.displayItem.change.Format()) (\(vm.displayItem.changePercent.Format())%)").WithChangeColor(vm.displayItem.change)
            }
            
        }.onAppear(perform: {
            vm.OnAppear(container)
        })
    }
    
    init(_ item : PortfolioItem){
        vm = ViewModel(item)
    }
}

extension MainPortfolioItemView{
    class ViewModel : ObservableObject{
        private let item : PortfolioItem
        @Published var displayItem : DisplayItem
        init(_ item : PortfolioItem){
            self.item = item
            self.displayItem = DisplayItem(item, item.avgPrice)
        }
        func OnAppear(_ container : ServiceContainer){
            _ = container.GetHttpService().Get(id: self.item.id).subscribe{ (stats : ApiStats) in
                self.displayItem = DisplayItem(self.item, stats.current)
            }
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
        MainPortfolioItemView(PortfolioItem.Default())
    }
}
