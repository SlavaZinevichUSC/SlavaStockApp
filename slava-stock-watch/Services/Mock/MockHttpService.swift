//
//  MockHttpService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import Foundation
import RxSwift

class MockHttpService : IHttpService{
    func Get<T>(id: String) -> Observable<T> where T : ApiCallable {
        let subject = PublishSubject<T>()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            subject.onNext(T.Default())
        }
        return subject
    }
    
    
    func Get<T>(id: String, completion: @escaping (T) -> Void) where T : ApiCallable {
        completion(T.Default())
    }
   
}
