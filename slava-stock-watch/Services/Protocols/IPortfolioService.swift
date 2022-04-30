//
//  IPortfolioService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation

protocol IPortfolioService{
    func SavePorfolioFile(id : String, name : String, value : Double)
    func SavePortfolioFile(_ item: PortfolioItem)
    func GetPorfolioFiles() -> [PortfolioItem]
}
