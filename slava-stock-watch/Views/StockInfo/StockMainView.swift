//
//  StockMainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

struct StockMainView: View {
    private let id : String
    @EnvironmentObject var factory : ServiceFactory
    var body: some View {
        NavigationView{
            List{
                Section(){
                    StockSummaryView(id, factory: factory)
                }
                Section(){
                    StockStatsView(id, factory).navigationTitle("Stats")
                }
            }
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
