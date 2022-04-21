//
//  ServiceFactory.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

import SwiftUI

class ServiceFactory : ObservableObject{
    private let factory = ProdServiceFactory()
    func GetHttpService() -> IHttpService {
        return factory.GetHttpService()
    }
}

extension ServiceFactory{
    
    class ProdServiceFactory{
        private let httpService : IHttpService = HttpService()

        func GetHttpService() -> IHttpService{
            return httpService
        }
    }
}
