//
//  ManagerContainer.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import Foundation
import CoreData

protocol IManagerContainer{
    var portfolioManager : IPortfolioManager {get}
    var watchlistManager : IWatchlistManager {get}
}

class ManagerContainer : IManagerContainer{
    
    let portfolioManager : IPortfolioManager
    let watchlistManager : IWatchlistManager
    
    init(){
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores{ (description, error) in
            if let e = error {
                fatalError("Failed to load Data Model: \(e.localizedDescription)")
            }
        }
        portfolioManager = PortfolioManager(container)
        watchlistManager = WatchlistManager(container)
    }
}
