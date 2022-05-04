//
//  ServiceFactory.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI


//Okay this Separation is TERRIBLE for Debug/Release abstraction but

//ALSO. MODEL DATA VIA RX OBSERVABLES ONLY!!!!!!!!!!
class ServiceContainer : ObservableObject {
    private let container : IContainerComponent
    
    init(_ managerContainer : IManagerContainer){
        container = ProdServiceContainer(managerContainer)
    }
    func GetHttpService() -> IHttpService {
        return container.httpService
    }
    
    func GetPortfolioDataService() -> IPortfolioDataService{
        return container.portfolioDataService
    }
    
    func GetWatchlistService() -> IWatchlistService{
        return container.watchlistService
    }
}

protocol IContainerComponent{
    var httpService : IHttpService {get}
    var portfolioDataService : IPortfolioDataService {get}
    var watchlistService : IWatchlistService {get}
}

extension ServiceContainer{
    
    class CustomContainerComponent : IContainerComponent{
        let httpService: IHttpService
        let portfolioDataService: IPortfolioDataService
        let watchlistService: IWatchlistService
        
        init(httpService : IHttpService,
             portfolioDataService : IPortfolioDataService,
             watchlistService : IWatchlistService){
            self.httpService = httpService
            self.portfolioDataService = portfolioDataService
            self.watchlistService = watchlistService
        }
    }
}
extension ServiceContainer{
    
    class ProdServiceContainer : IContainerComponent{
        let httpService : IHttpService = HttpService()
        let portfolioDataService: IPortfolioDataService
        let watchlistService: IWatchlistService
        
        init(_ managerContainer : IManagerContainer){
            let portfolioService = PortfolioService(managerContainer.portfolioManager)
            portfolioDataService = PortfolioDataService(portfolioService)
            watchlistService = WatchlistService(managerContainer.watchlistManager)
        }
        
    }
}
extension ServiceContainer{
    
    class DebugServiceContainer : IContainerComponent{
        let httpService: IHttpService
        let portfolioDataService: IPortfolioDataService
        let watchlistService: IWatchlistService
        
        init(_ managerContainer : IManagerContainer){
            httpService = HttpService()
            let portfolioService = PortfolioService(managerContainer.portfolioManager)
            portfolioDataService = PortfolioDataService(portfolioService)
            watchlistService = WatchlistService(managerContainer.watchlistManager)
        }
    }
}


extension ServiceContainer{
    static func Production() -> ServiceContainer{
        return ServiceContainer(ManagerContainer())
    }
    
    static func Preview() -> ServiceContainer{
        return ServiceContainer(ManagerContainer())
    }
    
    static func Current() -> ServiceContainer{
        return ServiceContainer.Production()
    }
}
