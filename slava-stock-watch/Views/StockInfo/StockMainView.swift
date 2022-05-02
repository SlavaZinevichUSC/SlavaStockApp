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
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 10){
                    Section(){
                        StockSummaryMainView().environmentObject(vm.commonData)
                        Spacer()
                    }
                    AsSection("Stats", StockStatsView().environmentObject(vm.commonData))
                    
                    AsSection("About",StockAboutView().environmentObject(vm.commonData))
                    
                    AsSection("Portfolio", StockPortfolioView(vm.id, container).environmentObject(vm.commonData))
                    
                    AsSection("Insights", StockInsightsView().environmentObject(vm.commonData))
                    
                    AsSection("News", StockNewsView(vm.id, container))
                    
                }
            }
            .navigationTitle(vm.profile.name)
            .navigationBarHidden(true)
        }.onAppear(perform: {
            vm.OnAppear(container.GetHttpService())
        })
    }
    
    
    init(_ result: ApiSearchItem, _ container : ServiceContainer){
        self.vm = ViewModel(result, container)
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
        let id : String
        let commonData : StockCommonData
        
        init(_ search : ApiSearchItem, _ container : ServiceContainer){
            id = search.id
            commonData = StockCommonData(search.id, search.name, container)
        }
        func OnAppear(_ http: IHttpService){
            http.Get(id: id, completion: { data in
                self.profile = data
            })
        }
        
        
    }
}



struct StockMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockMainView(ApiSearchItem.Default(), ServiceContainer.Current())
    }
}
