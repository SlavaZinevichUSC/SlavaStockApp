//
//  ServiceFactory.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

class ServiceFactory : IServiceFactory{
    private let factory : ProdServiceFactory
    
    init(_ portfolioManager : IPortfolioManager){
        factory = ProdServiceFactory(portfolioManager)
    }
    func GetHttpService() -> IHttpService {
        return factory.GetHttpService()
    }
}

extension ServiceFactory{
    
    class ProdServiceFactory{
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

extension ServiceFactory{
    static func Default() -> ServiceFactory{
        return ServiceFactory(PortfolioManager())
    }
}
