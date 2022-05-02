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
    
    init(_ portfolioManager : IPortfolioManager){
        container = ProdServiceContainer(portfolioManager)
    }
    func GetHttpService() -> IHttpService {
        return container.httpService
    }
    
    func GetPortfolioService() -> IPortfolioService{
        return container.portfolioService
    }
    
    func GetPortfolioDataService() -> IPortfolioDataService{
        return container.portfolioDataService
    }
}

protocol IContainerComponent{
    var httpService : IHttpService {get}
    var portfolioService : IPortfolioService {get}
    var portfolioDataService : IPortfolioDataService {get}
}

extension ServiceContainer{
    
    class CustomContainerComponent : IContainerComponent{
        let httpService: IHttpService
        let portfolioService: IPortfolioService
        let portfolioDataService: IPortfolioDataService
        
        init(httpService : IHttpService, portfolioService : IPortfolioService, portfolioDataService : IPortfolioDataService){
            self.httpService = httpService
            self.portfolioService = portfolioService
            self.portfolioDataService = portfolioDataService
        }
    }
}
extension ServiceContainer{
    
    class ProdServiceContainer : IContainerComponent{
        let httpService : IHttpService = HttpService()
        let portfolioService : IPortfolioService
        let portfolioDataService: IPortfolioDataService
        
        init(_ portfolioManager : IPortfolioManager){
            portfolioService = PortfolioService(portfolioManager)
            portfolioDataService = PortfolioDataService(portfolioService)
        }
        
    }
}
extension ServiceContainer{
    
    class DebugServiceContainer : IContainerComponent{
        let httpService: IHttpService
        let portfolioService: IPortfolioService
        let portfolioDataService: IPortfolioDataService
        
        init(_ portfolioManager : IPortfolioManager){
            httpService = HttpService()
            portfolioService = PortfolioService(portfolioManager)
            portfolioDataService = PortfolioDataService(portfolioService)
        }
    }
}


extension ServiceContainer{
    static func Production() -> ServiceContainer{
        return ServiceContainer(PortfolioManager())
    }
    
    static func Preview() -> ServiceContainer{
        return ServiceContainer(PortfolioManager())
    }
    
    static func Current() -> ServiceContainer{
        return ServiceContainer.Production()
    }
}
