//
//  IPortfolioManager.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation

protocol IPortfolioManager{
    func SavePortfolioFile(id : String, name : String, value : Double)
    func GetPortfolioFiles() -> [PortfolioFile]
}
