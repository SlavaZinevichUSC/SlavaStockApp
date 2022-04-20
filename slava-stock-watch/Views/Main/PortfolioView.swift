//
//  PortfolioView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject private var vm = ViewModel()
    var body: some View {
        NavigationView{
            HStack{
                /*Group{
                    VStack{
                        Text("Net Worth:")
                        Text("Cash Balance:")
                    }
                }*/
                List(vm.items) { item in
                    PortfolioItemView(item)
                }
            }
        }
    }
}

extension PortfolioView{
    class ViewModel : ObservableObject {
        let items : [PortfolioItem]
        init(){
            self.items = [PortfolioItem(id: "AAPL", name: "Apple")]
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
