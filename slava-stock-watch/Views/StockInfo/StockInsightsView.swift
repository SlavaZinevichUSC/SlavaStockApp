//
//  StockInsightsView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import SwiftUI

struct StockInsightsView: View {
    @StateObject var vm = SingleItemVM<ApiSentiments>()
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    
    var body: some View {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], alignment: .leading, spacing: 15){
            Group{
                AsLabel(commonData.name)
                AsLabel("Reddit")
                AsLabel("Twitter")
            }
            Group{
                AsLabel("Total")
                AsCount(vm.data.redditTotal)
                AsCount(vm.data.twitterTotal)
                
            }
            Group{
                AsLabel("Positive Mentions")
                AsCount(vm.data.redditPos)
                AsCount(vm.data.twitterPos)
               
            }
            Group{
                AsLabel("Negative Mentions")
                AsCount(vm.data.redditNeg)
                AsCount(vm.data.redditNeg)
            }
        }
        .onAppear(perform: {
            vm.Get(commonData, container.GetHttpService())
        })
    }
    
    
    private func AsLabel(_ text: String) -> some View{
        return Group{
            Text.Bold(text)
        }
    }
    
    private func AsCount(_ text: Int) -> some View{
        return Group{
            Text("\(text)")
        }
    }
}

struct StockInsightsView_Previews: PreviewProvider {
    static var previews: some View {
        StockInsightsView()
    }
}
