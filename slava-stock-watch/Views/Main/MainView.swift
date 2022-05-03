//
//  MainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/19/22.
//

import SwiftUI

struct MainView: View {
    @State private var searchText : String = ""
    @State private var isSearching : Bool = false
    @StateObject private var vm = ViewModel()
    @EnvironmentObject var container : ServiceContainer
    var body: some View {
        NavigationView{
            VStack{
                if(isSearching){
                    MainSearchView(vm.search)
                }
                else{
                    List{
                        MainDateView()
                        MainPortfolioView()
                    }
                    .listStyle(GroupedListStyle())
                }
            }
        }
        .navigationTitle("Slava`s stock watch")
        .searchable(text: $searchText){
           
        }
        .onChange(of: searchText){ text in
            if(text == ""){
                isSearching = false
            }
            vm.Reset(text)
        }
        .onSubmit(of: .search) {
            isSearching = searchText != ""
            vm.GetMatches(searchText, container.GetHttpService())
        }
    }
}

extension MainView{
    class ViewModel : ObservableObject{
        @Published var search : ApiSearch = ApiSearch.Default()
        func GetMatches(_ text : String, _ http : IHttpService){
            if(text == ""){
                self.search = ApiSearch.Default()
            }
            else{
                _ = http.Get(id: text).subscribe{ (result : ApiSearch) in
                    self.search = result
                }
                //self.search = ApiSearch([ApiSearchItem("TSLA", "Tesla"), ApiSearchItem("AAPL", "Apple Inc.")])
            }
        }
        
        func Reset(_ text : String){
            if(text == ""){
                self.search = ApiSearch.Default()
            }
        }

    }
}

extension MainView{
    struct SearchView : View{
        private let searchList : ApiSearch
        private let container : ServiceContainer
        var body: some View{
            Section{
                ForEach(searchList.searchResults, id: \.id){item in
                    NavigationLink(destination: StockMainView(item, container)){
                        VStack{
                            Text.Bold(item.name)
                            Text("\(item.id)")
                        }
                    }
                }
            }
        }
        
        init(_ searchList : ApiSearch, _ container : ServiceContainer){
            self.searchList = searchList
            self.container = container
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
