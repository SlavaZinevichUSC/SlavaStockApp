//
//  PortfolioService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation

class PortfolioService: IPortfolioService{
    private let initValue : Double = 10000
    private let manager : IPortfolioManager
    
    init(_ manager : IPortfolioManager){
        self.manager = manager
    }
    func SavePortfolioFile(_ item: PortfolioItem) -> Bool {
        if(!item.HasShares()){
            return manager.DeletePortfolioFile(url: item.url)
        }
        return manager.SavePortfolioFile(id: item.id,
                                         name: item.name,
                                         value: item.avgPrice,
                                         shares: item.shares,
                                         url: item.url)
    }
    
    func GetPorfolioFiles() -> [PortfolioItem] {
        return manager.GetPortfolioFiles().map { (file) -> PortfolioItem in
                return ToItem(file)
        }
    }
    
    func GetPortfolioFile(_ id : String) -> PortfolioItem? {
        let fileOpt = manager.GetPortfolioFiles().first{$0.id == id}
        guard let file = fileOpt else{
            return nil
        }
        return ToItem(file)
    }
    
    func GetCash() -> CashItem {
        var cashOpt = manager.GetPortfolioCash()
        if let cash = cashOpt {
            return CashItem(money: cash.cash, url: cash.objectID.uriRepresentation())
        }
        manager.CreatePortfolioCash(initValue: initValue)
        cashOpt = manager.GetPortfolioCash()
        if let cash = cashOpt {
            return CashItem(money: cash.cash, url: cash.objectID.uriRepresentation())
        }
        return CashItem(money: initValue, url: nil) //IF you're here shit is fucked
    }
    
    func UpdateCash(_ cash : CashItem) -> CashItem{
        let cashOpt = manager.UpdatePortfolioCash(money: cash.money, urlOpt: cash.url)
        if let cash = cashOpt {
            return CashItem(money: cash.cash, url: cash.objectID.uriRepresentation())
        }
        return CashItem(money: initValue, url: nil) //IF you're here shit is fucked
    }
    
    
    func Reset(){
        manager.Reset()
    }
    private func ToItem(_ file : PortfolioFile) -> PortfolioItem{
        PortfolioItem(id: file.id ?? "SCB", name: file.name ?? "Booby-Scoobs", avgPrice: file.avgPrice, shares: Int(file.shares), url: file.objectID.uriRepresentation())
    }
}
