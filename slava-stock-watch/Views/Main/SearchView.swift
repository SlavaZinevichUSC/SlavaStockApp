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
        HStack{
            TextField("enter ticker",text: $searchText)
        }
    }
}

extension SearchView{
    class ViewModel : ObservableObject {
        @Published var searchList = [String]()
        
        init() {
            searchList = ["TSLA", "AAPL"]
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
