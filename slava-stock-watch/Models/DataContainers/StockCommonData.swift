//
//  StockCommonData.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation
import RxSwift

class StockCommonData : ObservableObject{
    let stats : SharedApiData<ApiStats>
    let profile : SharedApiData<ApiProfile>
    let id : String
    
    init(_ id: String, _ http : IHttpService){
        self.id = id
        stats = SharedApiData<ApiStats>(id, http)
        profile = SharedApiData<ApiProfile>(id, http)
    }
}

class SharedApiData<T : ApiCallable>{
    let observable : BehaviorSubject<T>
    private let id : String
    private let http : IHttpService
    private var isBusy = false
    
    init(_ id : String, _ http : IHttpService){
        self.id = id
        observable = BehaviorSubject<T>(value: T.Default())
        self.http = http
        Get()
    }
    
    func Request(){
        if(isBusy) { return }
        isBusy = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.isBusy = false //very ugly
        }
        Get()
        
    }
    
    private func Get(){
        http.Get(id: self.id){ stats in
            self.observable.onNext(stats)
        }
    }
}
