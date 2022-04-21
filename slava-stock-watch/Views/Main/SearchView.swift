//
//  SearchView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/19/22.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject private var vm = ViewModel()
    @State private var searchText = ""
    
    
    var body: some View {
        List(vm.searchList, id: \.self){item in
            NavigationLink(destination: StockMainView(item)){
                Text("\(item)")
                .onTapGesture {
                    self.OnClick(item)
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchText,
                  perform: { _ in
            self.vm.OnTextChanged(searchText)
        })
        .navigationTitle("Ticker")
    }
}

extension SearchView{
    func OnClick(_ item : String){
        self.searchText = item
    }
}

extension SearchView{
    class ViewModel : ObservableObject {
        @Published var searchList = [String]()
        
        init() {
            self.searchList = []
        }
        
        func OnTextChanged(_ text : String) -> Void{
            self.searchList = ["TSLA", "AAPL"]
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
