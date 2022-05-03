//
//  IPortfolioService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation

protocol IPortfolioService{
    func SavePortfolioFile(_ item: PortfolioItem) -> Bool
    func GetPorfolioFiles() -> [PortfolioItem]
    func GetPortfolioFile(_ id : String) -> PortfolioItem?
    
    func GetCash() -> CashItem
    func UpdateCash(_ cash : CashItem) -> CashItem
    
    func Reset()
}
