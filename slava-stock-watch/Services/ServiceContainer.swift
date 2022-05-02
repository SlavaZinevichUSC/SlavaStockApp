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
    
    func GetPortfolioDataService() -> IPortfolioDataService{
        return container.portfolioDataService
    }
}

protocol IContainerComponent{
    var httpService : IHttpService {get}
    var portfolioDataService : IPortfolioDataService {get}
}

extension ServiceContainer{
    
    class CustomContainerComponent : IContainerComponent{
        let httpService: IHttpService
        let portfolioDataService: IPortfolioDataService
        
        init(httpService : IHttpService, portfolioDataService : IPortfolioDataService){
            self.httpService = httpService
            self.portfolioDataService = portfolioDataService
        }
    }
}
extension ServiceContainer{
    
    class ProdServiceContainer : IContainerComponent{
        let httpService : IHttpService = HttpService()
        let portfolioDataService: IPortfolioDataService
        
        init(_ portfolioManager : IPortfolioManager){
            let portfolioService = PortfolioService(portfolioManager)
            portfolioDataService = PortfolioDataService(portfolioService)
        }
        
    }
}
extension ServiceContainer{
    
    class DebugServiceContainer : IContainerComponent{
        let httpService: IHttpService
        let portfolioDataService: IPortfolioDataService
        
        init(_ portfolioManager : IPortfolioManager){
            httpService = HttpService()
            let portfolioService = PortfolioService(portfolioManager)
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
