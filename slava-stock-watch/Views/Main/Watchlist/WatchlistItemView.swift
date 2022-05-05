//
//  WatchlistItemView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import SwiftUI

struct WatchlistItemView: View {
    @ObservedObject var vm : ViewModel
    @EnvironmentObject var container : ServiceContainer
    var body: some View {
        NavigationLink(destination: StockMainView(vm.destination)){
            HStack(spacing: 2){
                VStack{
                    Text.Bold(vm.item.id)
                    Text("\(vm.item.name)").font(.caption)
                }.padding(.horizontal, 40)
                GetArrow()
                VStack{
                    Text.Bold("$\(vm.stats.current.Format())")
                    Text("$\(vm.change.Format()) (\(vm.changePercent.Format())%)").WithChangeColor(vm.change)
                }
            }
            
        }.onAppear(perform: {
            vm.Activate(container)
        })
        
    }
    
    init(_ item : WatchlistItem){
        self.vm = ViewModel(item)
    }
}

extension WatchlistItemView{
    func GetArrow() -> some View {
        let isUp = vm.change > 0
        let arrow = isUp ? "arrow.up.right" : "arrow.down.right"
        return Image(systemName: arrow).foregroundColor(isUp ? Color.green : Color.red)
    }
}

extension WatchlistItemView{
    class ViewModel : ObservableObject{
        @Published var item : WatchlistItem
        @Published var stats : ApiStats = ApiStats.Default()
        var destination : ApiSearchItem {
            return ApiSearchItem(item.id, item.name)
        }
        var change : Double {
            return stats.current - stats.prevClose
        }
        var changePercent : Double {
            return change / stats.prevClose
        }
        
        init(_ item : WatchlistItem){
            self.item = item
        }
        
        func Activate(_ container : ServiceContainer){
            _ = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { _ in
                _ = container.GetHttpService().Get(id: self.item.id).subscribe{data in
                    self.stats = data
                }
            })
            _ = container.GetHttpService().Get(id: item.id).subscribe{data in
                self.stats = data
            }
        }
    }
}

struct WatchlistItemView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistItemView(WatchlistItem.Default())
    }
}
