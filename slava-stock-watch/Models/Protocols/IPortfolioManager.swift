//
//  IPortfolioManager.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation

protocol IPortfolioManager{
    func SavePortfolioFile(id : String, name : String, value : Double, shares : Int, url : URL?) -> Bool
    func GetPortfolioFiles() -> [PortfolioFile]
    func GetPortfolioCash() -> PortfolioCashFile?
    func DeletePortfolioFile(url : URL?) -> Bool
    
    func CreatePortfolioCash(initValue : Double)
    func UpdatePortfolioCash(money : Double, urlOpt : URL?) -> PortfolioCashFile?
    
    func Reset()
}
