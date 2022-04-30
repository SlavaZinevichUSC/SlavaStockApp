//
//  ServiceFactory.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

class ServiceContainer : IServiceFactory{
    private let factory : ProdServiceContainer
    
    init(_ portfolioManager : IPortfolioManager){
        factory = ProdServiceContainer(portfolioManager)
    }
    func GetHttpService() -> IHttpService {
        return factory.GetHttpService()
    }
}

extension ServiceContainer{
    
    class ProdServiceContainer{
        private let httpService : IHttpService = HttpService()
        private let portfolioService : IPortfolioService
        
        init(_ portfolioManager : IPortfolioManager){
            portfolioService = PortfolioService(portfolioManager)
        }

        func GetHttpService() -> IHttpService{
            return httpService
        }
    }
}

extension ServiceContainer{
    static func Default() -> ServiceContainer{
        return ServiceContainer(PortfolioManager())
    }
}
