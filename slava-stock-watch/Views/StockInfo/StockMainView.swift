//
//  StockMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

struct StockMainView: View {
    @ObservedObject private var vm : ViewModel
    @EnvironmentObject var container : ServiceContainer
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    LazyVStack(alignment: .leading, spacing: 10){
                        Section(){
                            StockSummaryMainView().environmentObject(vm.commonData)
                            Spacer()
                        }
                        AsSection("Stats", StockStatsView().environmentObject(vm.commonData))
                        AsSection("About",StockAboutView().environmentObject(vm.commonData))
                        AsSection("Portfolio", StockPortfolioView(vm.search.id, container).environmentObject(vm.commonData))
                        AsSection("Insights", StockInsightsView().environmentObject(vm.commonData))
                        AsSection("News", StockNewsView(vm.search.id, container))
                        
                    }
                }
                .navigationTitle(vm.profile.name)
                .navigationBarHidden(true)
                
                if(vm.isLoading){
                    LoadingView()
                }
            }
        }.onAppear(perform: {
            vm.OnAppear(container)
        })
        .toolbar {
            Button(action: {
                vm.ToggleWatchlist(container)
            }, label: {
                if(vm.watchlistItem.IsOnWatchlist()){
                    Image(systemName: "plus.circle.fill")
                }
                else {
                    Image(systemName: "plus.circle")
                }
            })
        }
    }
    
    
    init(_ result: ApiSearchItem){
        self.vm = ViewModel(result)
    }
}

extension StockMainView{
    func Header(_ text : String) -> some View{
        return Text.Header(text).padding()
    }
    
    func AsSection<T : View>(_ text : String, _ item : T) -> some View{
        return Group{
            Header(text)
            item
            Spacer()
        }
    }
}

extension StockMainView{
    class ViewModel : ObservableObject{
        @Published var profile : ApiProfile = ApiProfile.Default()
        @Published var isLoading : Bool = true
        @Published var watchlistItem : WatchlistItem = WatchlistItem.Default()
        
        let search : ApiSearchItem
        var commonData : StockCommonData
        
        init(_ search : ApiSearchItem){

            self.search = search
            commonData = StockCommonData.Empty()
        }
        func OnAppear(_ container: ServiceContainer){
            commonData = StockCommonData(search.id, search.name, container)
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.isLoading = false
            }
            _ = commonData.profile.observable.subscribe{data in
                self.profile = data
            }
            let itemObs = container.GetWatchlistService().GetWatchlistItem(search.id, name: profile.name)
            _ = itemObs.asObservable().subscribe{data in
                self.watchlistItem = data
            }
            commonData.Refresh()
        }
        
        func ToggleWatchlist(_ container : ServiceContainer){
            let watchlist = container.GetWatchlistService()
            if(watchlistItem.IsOnWatchlist()) {
                watchlist.DeleteFile(self.watchlistItem)
            }
            else{
                watchlist.SaveFile(self.watchlistItem)
            }
        }
        
    }
}



struct StockMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockMainView(ApiSearchItem.Default())
    }
}
