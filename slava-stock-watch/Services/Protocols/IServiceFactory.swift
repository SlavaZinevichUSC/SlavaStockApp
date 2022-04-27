//
//  IServiceFactory.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/21/22.
//

import Foundation

protocol IServiceFactory : ObservableObject{
    func GetHttpService() -> IHttpService
}
