//
//  StockMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

struct StockMainView: View {
    private let id : String
    var body: some View {
        NavigationView{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationTitle("Stock main")
    }
    
    init(_ id: String){
        self.id = id
    }
}

struct StockMainView_Previews: PreviewProvider {
    static var previews: some View {
        StockMainView("TSLA")
    }
}
