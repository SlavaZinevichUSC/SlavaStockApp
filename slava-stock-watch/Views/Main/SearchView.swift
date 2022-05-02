//
//  SearchView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/19/22.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject private var vm = ViewModel()
    @EnvironmentObject var container : ServiceContainer
    @State private var searchText = ""
    
    
    var body: some View {
        List(vm.searchList, id: \.id) {item in
            NavigationLink(destination: StockMainView(item, container)){
                Text("\(item.id)")
                .onTapGesture {
                    self.OnClick(item.id)
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText,
                  perform: { _ in
            self.vm.OnTextChanged(searchText)
        })
        .navigationTitle("Stocks")
    }
}

extension SearchView{
    func OnClick(_ item : String){
        self.searchText = item
    }
}

extension SearchView{
    class ViewModel : ObservableObject {
        @Published var searchList  : [ApiSearchItem]
        
        init() {
            self.searchList = [ApiSearchItem("TSLA", "Tesla"), ApiSearchItem("AAPL", "Apple Inc.")]
        }
        
        func OnTextChanged(_ text : String) -> Void{
            self.searchList = [ApiSearchItem("TSLA", "Tesla"), ApiSearchItem("AAPL", "Apple Inc.")]
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
