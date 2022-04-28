//
//  StockInsightsView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import SwiftUI

struct StockInsightsView: View {
    @ObservedObject var vm : ViewModel
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], alignment: .leading, spacing: 15){
            Group{
                AsLabel("Total")
                AsCount(vm.sentiments.redditTotal)
                AsCount(vm.sentiments.twitterTotal)
                
            }
            Group{
                AsLabel("Positive Mentions")
                AsCount(vm.sentiments.redditPos)
                AsCount(vm.sentiments.twitterPos)
               
            }
            Group{
                AsLabel("Negative Mentions")
                AsCount(vm.sentiments.redditNeg)
                AsCount(vm.sentiments.redditNeg)
            }
        }
    }
    
    
    init(_ id: String, _ factory : ServiceFactory){
        vm = ViewModel(id, factory.GetHttpService())
    }
    
    private func AsLabel(_ text: String) -> Text{
        return Text.Bold(text)
    }
    
    private func AsCount(_ text: Int) -> Text{
        return Text("\(text)")
    }
}

extension StockInsightsView{
    class ViewModel : ObservableObject{
        @Published var sentiments : ApiSentiments
        init(_ id : String, _ http : IHttpService){
            sentiments = ApiSentiments.Default()
            http.Get(id: id, completion: { data in
                self.sentiments = data
            })
        }
    }
}
struct StockInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        StockInsightsView("AAPL", ServiceFactory())
    }
}
