//
//  StockCommonData.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation
import RxSwift

class StockCommonData : ObservableObject{
    let stats : SharedStats
    let id : String
    
    init(_ id: String, _ http : IHttpService){
        self.id = id
        stats = SharedStats(id, http)
    }
}

class SharedStats{
    let statsObs : BehaviorSubject<ApiStats>
    private let id : String
    private let http : IHttpService
    private var isBusy = false
    
    init(_ id : String, _ http : IHttpService){
        self.id = id
        statsObs = BehaviorSubject<ApiStats>(value: ApiStats.Default())
        self.http = http
        Get()
    }
    
    func Request(){
        if(isBusy) { return }
        isBusy = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.isBusy = false //very ugly
        }
        Get()
        
    }
    
    private func Get(){
        http.Get(id: self.id){ stats in
            self.statsObs.onNext(stats)
        }
    }
}
