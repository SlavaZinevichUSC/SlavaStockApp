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
    
    
    init(id: String, name: String,  avgPrice : Double){
        self.id = id
        self.name = name
        self.avgPrice = avgPrice
    }
}
