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
    
    
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
}
