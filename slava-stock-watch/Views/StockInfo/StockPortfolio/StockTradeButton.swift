//
//  StockTradeButton.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import SwiftUI

//wrong -> Should subscribe.
//I Fucked up and did not immedately  used observables only
struct StockTradeButton: View {
    @ObservedObject var vm  : ViewModel = ViewModel()
    @State var showTrade = false
    @EnvironmentObject var serviceContainer : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    var body: some View {
        Button(action: {
            print("Pressed")
            self.showTrade.toggle()
            
        }, label: {
            Text("Trade")
                .frame(width: UIScreen.dScreenWidth25, height : 50)
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(10)
        })
        .sheet(isPresented: $showTrade){
            StockTradeView(vm.cash, $showTrade)
        }
        .onAppear(perform: {
            vm.Activate(commonData)
        })
    }
}

extension StockTradeButton{
    class ViewModel : ObservableObject{
        @Published var cash : CashItem
        @Published var item : PortfolioItem
        
        init(){
            self.cash = CashItem.Default()
            self.item = PortfolioItem.Default()
        }
        
        func Activate(_ commonData : StockCommonData){
            _ = commonData.cashObs.subscribe{data in
                self.cash = data
            }
            _ = commonData.portfolioObs.subscribe{data in
                self.item = data
            }
        }
    }
}

struct StockTradeButton_Previews: PreviewProvider {
    static var previews: some View {
        StockTradeButton()
    }
}
