//
//  CashItem.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation


struct CashItem {
    let money : Double
    
    static func Default() -> CashItem{
        return CashItem(money: 25000)
    }
}
