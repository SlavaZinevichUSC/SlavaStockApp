//
//  HttpService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//
import Alamofire
import RxSwift
import Foundation

final class HttpService : IHttpService{
    private let list : Array<AnyObject> = []
    private let url = "https://geogre-tiredbiter.wl.r.appspot.com"
    
    func Get<T : ApiCallable>(id : String) -> T{
        let callType = T.GetHttpName()
        let url = "\(url)/\(callType)/\(id)"
        var obj : T = T.Default()
        let req = AF.request(url, method: .get)
        req
        .responseDecodable(of: T.self) { response in
            guard let res = response.value else { return}
            print("Response DecodableType: \(res)")
            obj = res
        }
        return obj
    }
    
    func Get<T : ApiCallable>(id : String, completion: @escaping (_ data : T) -> Void){
        let callType = T.GetHttpName()
        let url = "\(url)/\(callType)/\(id)"
        let req = AF.request(url, method: .get)
        req
        .responseDecodable(of: T.self) { response in
            guard let res = response.value else {
                print(response.debugDescription)
                return
                
            }
            completion(res)
        }
    }
    
    func Get<T : ApiCallable>(id : String) -> Observable<T>{
        if(id == ""){
            print("Attempted to get on an empty id for \(T.self)")
            return Observable.empty()
        }
        let callType = T.GetHttpName()
        let url = "\(url)/\(callType)/\(id)"
        let req = AF.request(url, method: .get)
        let subject = PublishSubject<T>()
        req
        .responseDecodable(of: T.self) { response in
            guard let res = response.value else {
                print(response.debugDescription)
                subject.onNext(T.Default())
                return
                
            }
            subject.onNext(res)
        }
        return subject.asObservable()
    }
    
    
    
    
    
}
