//
//  HttpService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

final class HttpService : IHttpService{
    private let url = "https://geogre-tiredbiter.wl.r.appspot.com/"
    
    func GetProfile(_ id: String) -> ApiProfile{
        return ApiProfile()
    }
}
