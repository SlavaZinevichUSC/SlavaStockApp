//
//  WatchlistView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import SwiftUI

struct WatchlistView: View {
    @StateObject var vm = ViewModel()
    @EnvironmentObject var container : ServiceContainer
    var body: some View {
        Section("Favorites"){
            ForEach(vm.watchlist, id: \.id){item in
                WatchlistItemView(item)
            }
            .onDelete(perform: vm.Delete)
        }
        .onAppear(perform: {
            vm.Activate(container)
        })
    }
}

extension WatchlistView{
    class ViewModel : ObservableObject{
        @Published var watchlist : [WatchlistItem] = []
        private var container : ServiceContainer?
        
        func Activate(_ container : ServiceContainer){
            self.container = container
            _ = container.GetWatchlistService().GetWatchlist().subscribe{data in
                self.watchlist = data
            }
            
        }
        
        func Delete(at offsets: IndexSet){
            container?.GetWatchlistService().DeleteFiles(offsets.map{ watchlist[$0]})
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
    }
}
