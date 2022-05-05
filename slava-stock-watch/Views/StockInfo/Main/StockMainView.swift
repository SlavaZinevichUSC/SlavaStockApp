//
//  StockMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI
import AlertToast

struct StockMainView: View {
    @ObservedObject private var vm : ViewModel
    @EnvironmentObject var container : ServiceContainer
    @State var isPresentingToast : Bool = false
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
                        AsSection("Portfolio", StockPortfolioView(vm.commonData,  container).environmentObject(vm.commonData))
                        AsSection("Insights", StockInsightsMainView().environmentObject(vm.commonData))
                        AsSection("News", StockNewsView(vm.search.id, container))
                        
                    }
                }
                .navigationBarHidden(true)
                
                if(vm.isLoading){
                    LoadingView()
                }
            }
        }.onAppear(perform: {
            vm.OnAppear(container)
        })
        .navigationTitle(vm.profile.name)
        .toolbar {
            Button(action: {
                vm.ToggleWatchlist(container)
                isPresentingToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isPresentingToast = false
                })
            }, label: {
                if(vm.watchlistItem.IsOnWatchlist()){
                    Image(systemName: "plus.circle.fill")
                }
                else {
                    Image(systemName: "plus.circle")
                }
            })
        }
        .toast(isPresenting: $isPresentingToast, duration: 3, tapToDismiss: true){
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "\(vm.toastText)", style: AlertToast.AlertStyle.style(backgroundColor: Color.gray, titleColor: Color.white))
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
        @Published var watchlistItem : WatchlistItem
        let search : ApiSearchItem
        var commonData : StockCommonData
        var toastText : String{
            return watchlistItem.IsOnWatchlist() ? "Added to favorites" : "Removed from favorites"
        }
        
        init(_ search : ApiSearchItem){
            self.search = search
            watchlistItem = WatchlistItem(search.id, search.name, nil)
            commonData = StockCommonData.Empty()
            isLoading = true
            
        }
        func OnAppear(_ container: ServiceContainer){
            commonData = StockCommonData(search.id, search.name, container)
            
            _ = commonData.profile.observable.subscribe{data in
                self.profile = data
            }
            if(isLoading){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.isLoading = false
                }
            }
            let itemObs = container.GetWatchlistService().GetWatchlistItem(search.id, name: profile.name)
            _ = itemObs.asObservable().subscribe{(data : WatchlistItem) in
                self.watchlistItem = WatchlistItem(self.watchlistItem.id, self.watchlistItem.name, data.url)
            }
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
