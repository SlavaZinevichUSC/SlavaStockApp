//
//  StockStatsView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import SwiftUI
import RxSwift

struct StockStatsView: View {
    @ObservedObject var vm : StatsVM = StatsVM()
    @EnvironmentObject var commonData : StockCommonData
    private let id : String
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem()], alignment: .leading, spacing: 15){
            AsText("High Price:", vm.stats.high)
            AsText("Low Price:", vm.stats.low)
            AsText("Open Price:", vm.stats.open)
            AsText("Prev. Close:", vm.stats.prevClose)
        }
        .onAppear(perform: {
            vm.Subscribe(commonData.stats.statsObs)
        })
    }
    
    init(_ id : String, _ container : ServiceContainer){
        self.id = id
    }
    
    func AsText(_ text : String, _ value : Double) -> Text{
        return Text.Bold(text + " ").Double(value).AsInfo()
    }
    
    
}

struct StockStatsView_Previews: PreviewProvider {
    static var previews: some View {
        StockStatsView("AAPL", ServiceContainer.Current())
    }
}
