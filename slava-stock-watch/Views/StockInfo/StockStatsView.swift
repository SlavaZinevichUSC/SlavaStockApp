//
//  StockStatsView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import SwiftUI

struct StockStatsView: View {
    @ObservedObject var vm : ViewModel
    private let id : String
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                AsText("High Price:", vm.stats.high).padding(.bottom)
                AsText("Low Price:", vm.stats.low).padding(.bottom)
            }
            VStack(alignment: .leading){
                AsText("Open Price:", vm.stats.open).padding(.bottom)
                AsText("Prev. Close:", vm.stats.prevClose).padding(.bottom)
            }
        }
    }
    
    init(_ id : String, _ factory : ServiceFactory){
        self.id = id
        self.vm = ViewModel(id, factory.GetHttpService())
    }
    
    func AsText(_ text : String, _ value : Double) -> Text{
        let result = NSMutableAttributedString()
            .bold(text)
            .space()
            .normal(value.Format())
            .string
        return Text(result)
    }
    
    
}

extension StockStatsView{
    class ViewModel: ObservableObject{
        private let id : String
        @Published var stats : ApiStats
        init(_ id: String, _ http : IHttpService){
            self.id = id
            stats = ApiStats.Default()
            http.Get(id: id, completion: { data in
                self.HttpCallback(data)
            })
        }
        
        private func HttpCallback(_ stats: ApiStats){
            self.stats = stats
        }
    }
}
struct StockStatsView_Previews: PreviewProvider {
    static var previews: some View {
        StockStatsView("AAPL", ServiceFactory())
    }
}
