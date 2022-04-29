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
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 10){
                    Section(){
                        Header(vm.profile.name)
                        StockSummaryMainView(id)
                        Spacer()
                    }
                    AsSection("Stats", StockStatsView(id, factory))
                    
                    Section(){
                        Header("About")
                        StockAboutView(id, factory)
                    }
                    Section(){
                        Header("Insights")
                        StockInsightsView(id, factory)
                    }
                    Section{
                        Header("News")
                        StockNewsView(id, factory)
                    }
                }
            }
        }.onAppear(perform: {
            vm.OnAppear(id, factory.GetHttpService())
        })
    }
    
    
    init(_ id: String){
        self.id = id
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
