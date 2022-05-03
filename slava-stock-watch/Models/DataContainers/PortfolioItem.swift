//
//  PortfolioItem.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import Foundation
import SwiftUI
import CoreData


struct PortfolioItem: Identifiable, IPersistent{
    let id : String
    let name : String
    let avgPrice : Double
    let shares : Int
    let url : URL?
    var totalCost : Double {
        return avgPrice * Double(shares)
    }
    
    
    init(id: String, name: String,  avgPrice : Double, shares : Int, url : URL?){
        self.id = id
        self.name = name
        self.avgPrice = avgPrice
        self.shares = shares
        self.url = url
    }
    
    func HasShares() -> Bool {
        return shares > 0
    }
    
    func With(avgPrice : Double, shares : Int) -> PortfolioItem{
        return PortfolioItem(id: id, name: name, avgPrice: avgPrice, shares: shares, url: url)
    }
    
    static func Default() -> PortfolioItem{
        return PortfolioItem(id: "", name: "", avgPrice: 0, shares: 0, url: nil)
    }
    
    
}
