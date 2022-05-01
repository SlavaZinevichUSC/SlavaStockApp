//
//  StockMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

struct StockMainView: View {
    private let id : String
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
                    
                    AsSection("Portfolio", StockPortfolioView(id, container).environmentObject(vm.commonData))
                    
                    AsSection("Insights", StockInsightsView().environmentObject(vm.commonData))
                    
                    AsSection("News", StockNewsView(id, container))
                    
                }
            }
            .navigationTitle(vm.profile.name)
            .navigationBarHidden(true)
        }.onAppear(perform: {
            vm.OnAppear(id, container.GetHttpService())
        })
    }
    
    
    init(_ id: String, _ container : ServiceContainer){
        self.id = id
        self.vm = ViewModel(id, container)
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
        let commonData : StockCommonData
        
        init(_ id : String, _ container : ServiceContainer){
            commonData = StockCommonData(id, container.GetHttpService())
        }
        func OnAppear(_ id: String, _ http: IHttpService){
            http.Get(id: id, completion: { data in
                self.profile = data
            })
        }
        
        
    }
}



struct StockMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockMainView("TSLA", ServiceContainer.Current())
    }
}
