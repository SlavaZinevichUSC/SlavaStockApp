//
//  HttpService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//
import Alamofire

final class HttpService : IHttpService{
    private static let Map = [ApiGetType.Profile : "profile"]
    private let url = "https://geogre-tiredbiter.wl.r.appspot.com/"
    
    func Get<T : ApiCallable>(id : String) -> T{
        let callType = T.GetHttpName()
        let req = AF.request("\(url)/\(callType)/\(id)")
        var obj : T = T.Default()
        req.responseDecodable(of: T.self){ (response) in
            guard let resObj = response.value else {return}
            obj = resObj
        }
        return obj
    }
    
    
    
}
