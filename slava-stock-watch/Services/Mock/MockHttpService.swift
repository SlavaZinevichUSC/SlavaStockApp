//
//  MockHttpService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import Foundation


class MockHttpService : IHttpService{
    
    func Get<T>(id: String, completion: @escaping (T) -> Void) where T : ApiCallable {
        completion(T.Mock())
    }
    
    
}
