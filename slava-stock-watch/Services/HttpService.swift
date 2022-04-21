//
//  HttpService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//
import Alamofire

final class HttpService : IHttpService{
    private let url = "https://geogre-tiredbiter.wl.r.appspot.com/"
    
    func GetProfile(_ id: String) -> ApiProfile{
        let req = AF.request("\(url)/price/\(id)")
        var profile = ApiProfile.Default()
        req.responseDecodable(of: ApiProfile.self){ (response) in
            guard let resProfile = response.value else { return }
            profile = resProfile
        }
        return profile
    }
}
