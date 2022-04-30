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
    func SavePorfolioFile(id: String, name: String, value: Double) {
        manager.SavePortfolioFile(id: id, name: name, value: value)
    }
    
    func SavePortfolioFile(_ item: PortfolioItem) {
        SavePorfolioFile(id: item.id, name: item.name, value: item.avgPrice)
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
        let cashOpt = manager.GetPortfolioCash()
        if let cash = cashOpt {
            return CashItem(money: cash.cash)
        }
        manager.CreatePortfolioCash(initValue: initValue)
        return CashItem(money: initValue) //Cheat. Should re-request it but oh well
    }
    
    
    private func ToItem(_ file : PortfolioFile) -> PortfolioItem{
        PortfolioItem(id: file.id ?? "SCB", name: file.name ?? "Booby-Scoobs", avgPrice: file.avgPrice)
    }
}
