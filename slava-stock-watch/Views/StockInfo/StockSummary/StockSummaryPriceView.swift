//
//  StockSummaryPriceView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import SwiftUI

struct StockSummaryPriceView: View {
    @ObservedObject var vm : StatsVM = StatsVM()
    @EnvironmentObject var commonData : StockCommonData
    var body: some View {
        HStack(){
            Text("$").Double(vm.stats.current).Space().font(.title).bold()
            TextChange(vm.stats.change)
            Spacer()
        }
        .onAppear(perform: {
            vm.Subscribe(commonData.stats.observable)
            
        })
    }
    
}

extension StockSummaryPriceView{
    func TextChange(_ value : Double) -> some View{
        let color = value > 0 ? Color.green : Color.red
        return Group {
                Image(systemName: "arrow.up.right")
                Text(" ").Double(value)
            }
            .foregroundColor(color)
            .font(.title)
        
    }
}

struct StockSummaryPriceView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryPriceView()
    }
}
