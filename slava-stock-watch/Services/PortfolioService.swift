//
//  PortfolioService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation

class PortfolioService: IPortfolioService{
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
                return PortfolioItem(id: file.id ?? "", name: file.name ?? "", avgPrice: file.avgPrice)
        }
    }

}
