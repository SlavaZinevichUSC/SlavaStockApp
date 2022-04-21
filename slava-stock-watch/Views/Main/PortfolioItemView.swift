//
//  PortfolioItemView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

struct PortfolioItemView: View {
    private let item : PortfolioItem
    var body: some View {
        HStack{
            Group{
                Text("\(self.item.name)")
            }
            Group{
                Text("\(self.item.id)")
            }
        }
        
    }
    
    init(_ item : PortfolioItem){
        self.item = item
    }
}

struct PortfolioItemView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioItemView(PortfolioItem(id: "AAPL", name: "Apple"))
    }
}
