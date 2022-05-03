//
//  CashItem.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation


struct CashItem : IPersistent{
    let money : Double
    let url : URL?
    
    func With(_ money : Double) -> CashItem{
        return CashItem(money : money, url: url)
    }
    
    func Adjust(_ delta : Double) -> CashItem{
        let adjusted = money + delta
        if(adjusted < 0) {
            print("You're Fucked, you made your cash negative fool")
        }
        return CashItem(money: adjusted, url: url)
    }
    static func Default() -> CashItem{
        return CashItem(money: 25000, url: nil)
    }
}
