//
//  IPortfolioDataService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import Foundation
import RxSwift

protocol IPortfolioDataService {
    func GetPortfolioItemObs(_ id : String, _ name : String) -> Observable<PortfolioItem>
    func GetCashObs() -> Observable<CashItem>
    func SavePortfolioItem(_ item : PortfolioItem, _ cash : CashItem)

}
