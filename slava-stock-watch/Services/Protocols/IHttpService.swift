//
//  IHttpService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//


protocol IHttpService{    
    func Get<T : ApiCallable>(id : String) -> T
}
