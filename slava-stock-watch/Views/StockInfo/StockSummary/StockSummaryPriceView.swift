//
//  StockSummaryPriceView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import SwiftUI

struct StockSummaryPriceView: View {
    @ObservedObject var vm : ViewModel
    var body: some View {
        HStack(){
            Text("$").Double(vm.price.current).Space().font(.title).bold()
            TextChange(vm.price.change)
            Spacer()
        }
    }
    
    init(_ id : String, _ factory : ServiceFactory){
        vm = ViewModel(id, factory.GetHttpService())
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

extension StockSummaryPriceView{
    class ViewModel : ObservableObject{
        @Published var price : ApiStats = ApiStats.Default()
        init(_ id : String, _ http : IHttpService){
            http.Get(id: id, completion: { data in
                self.price = data
            })
        }
    }
}

struct StockSummaryPriceView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryPriceView("AAPL", ServiceFactory.Default())
    }
}
