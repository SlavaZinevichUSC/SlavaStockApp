//
//  PortfolioItem.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import Foundation
import SwiftUI

struct PortfolioItem: Identifiable{
    let id : String
    let name : String
    let avgPrice : Double
    let shares : Int
    
    
    init(id: String, name: String,  avgPrice : Double, shares : Int = 0){
        self.id = id
        self.name = name
        self.avgPrice = avgPrice
        self.shares = shares
    }
    
    static func Default() -> PortfolioItem{
        return PortfolioItem(id: "", name: "", avgPrice: 0)
    }
}
