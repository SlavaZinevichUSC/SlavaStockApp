//
//  StockMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

struct StockMainView: View {
    private let id : String
    @ObservedObject private var vm = ViewModel()
    @EnvironmentObject var factory : ServiceFactory
    var body: some View {
        NavigationView{
            List{
                Section(header: "Summary".AsText()){
                    StockSummaryView(id, factory: factory)
                }
                Section(header: "Stats".AsText()){
                    StockStatsView(id, factory)
                }
                Section(header: "About".AsText()){
                    StockAboutView(id, factory)
                }
                Section(header: "Insights".AsText()){
                    StockInsightsView(id, factory)

                }
            }
            .navigationTitle(vm.profile.name)
            .onAppear(perform: {
                vm.OnAppear(id, factory.GetHttpService())
            })
        }
    }
        
    
    init(_ id: String){
        self.id = id
    }
}

extension StockMainView{
    class ViewModel : ObservableObject{
        @Published var profile : ApiProfile = ApiProfile.Default()
        
        func OnAppear(_ id: String, _ http: IHttpService){
            http.Get(id: id, completion: { data in
                self.profile = data
            })
        }
    }
}



struct StockMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockMainView("TSLA")
    }
}
