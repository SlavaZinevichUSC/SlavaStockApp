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
    var id : String {
        profile.value.id
    }
    var name : String {
        return profile.value.name
    }
    let portfolioObs : Observable<PortfolioItem>
    let cashObs : Observable<CashItem>
    
    
    init(_ id: String, _ name: String, _ container : ServiceContainer){
        let http = container.GetHttpService()
        let portfolio = container.GetPortfolioDataService()
        stats = SharedApiData<ApiStats>(id, http)
        profile = SharedApiData<ApiProfile>(id, http)
        self.portfolioObs = portfolio.GetPortfolioItemObs(id, name)
        self.cashObs = portfolio.GetCashObs()
    }
    
    func Refresh(){
        stats.Request()
        profile.Request()
    }
}

struct SharedApiData<T : ApiCallable>{
    let subject : BehaviorSubject<T>
    private let id : String
    private let http : IHttpService
    private var isBusy = false
    var value : T {
        do{
            return try subject.value()
        } catch {
            Get() //Reeeaaallly shouldn't happen so hope this will rectify 
            return T.Default()
        }
    }
    var observable : Observable<T>{
        return subject.asObservable()
    }
    
    init(_ id : String, _ http : IHttpService){
        self.id = id
        subject = BehaviorSubject<T>(value: T.Default())
        self.http = http
        Get()
    }
    
    func Request(){
        Get()
        
    }
    
    private func Get(){
        http.Get(id: self.id){ stats in
            self.subject.onNext(stats)
        }
    }
}
