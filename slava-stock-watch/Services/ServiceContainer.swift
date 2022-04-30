//
//  ServiceFactory.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI


//Okay this Separation is TERRIBLE for Debug/Release abstraction but 
class ServiceContainer : ObservableObject {
    private let container : ProdServiceContainer
    
    init(_ portfolioManager : IPortfolioManager){
        container = ProdServiceContainer(portfolioManager)
    }
    func GetHttpService() -> IHttpService {
        return container.httpService
    }
    
    func GetPortfolioService() -> IPortfolioService{
        return container.portfolioService
    }
}

protocol IContainerComponent{
    var httpService : IHttpService {get}
    var portfolioService : IPortfolioService {get}
}

extension ServiceContainer{
    
    class CustomContainerComponent : IContainerComponent{
        let httpService: IHttpService
        let portfolioService: IPortfolioService
        
        init(httpService : IHttpService, portfolioService : IPortfolioService){
            self.httpService = httpService
            self.portfolioService = portfolioService
        }
    }
}
extension ServiceContainer{
    
    class ProdServiceContainer : IContainerComponent{
        let httpService : IHttpService = HttpService()
        let portfolioService : IPortfolioService
        
        init(_ portfolioManager : IPortfolioManager){
            portfolioService = PortfolioService(portfolioManager)
        }
        
    }
}
extension ServiceContainer{
    
    class DebugServiceContainer : IContainerComponent{
        let httpService: IHttpService
        let portfolioService: IPortfolioService
        
        init(_ portfolioManager : IPortfolioManager){
            httpService = HttpService()
            portfolioService = PortfolioService(portfolioManager)
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
}
