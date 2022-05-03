//
//  PortfolioDataService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import Foundation
import RxSwift


//SO this will dublicate the DB
//WHICH IS BAD
//Ideally this is a lazy dictionary that stores Publish Subjects and retrieves as needed
//MAYBE ill change it. As long as the interface is agnostic to implementation this will be easy
//SO NO UNPROTECTED CALLS TO .VALUE
class PortfolioDataService : IPortfolioDataService{
    
    private let repo : IPortfolioService
    private let cashSubject : BehaviorSubject<CashItem>
    private var portfolioItems : Dictionary<String, BehaviorSubject<PortfolioItem>>
    private let portfolioSubject : BehaviorSubject<Dictionary<String, BehaviorSubject<PortfolioItem>>>

    init(_ repo : IPortfolioService){
        self.repo = repo
        repo.Reset()
        cashSubject = BehaviorSubject<CashItem>(value: repo.GetCash())
        portfolioItems = Dictionary()
        portfolioSubject = BehaviorSubject(value: portfolioItems)
        ConstructPortfolio()
    }
    
    func GetPortfolioItemObs(_ id : String, _ name : String) -> Observable<PortfolioItem>{
        let subjectOpt = portfolioItems[id]
        guard let subject = subjectOpt else{
            let newSubject = BehaviorSubject(value: PortfolioItem(id: id, name: name, avgPrice: 0, shares: 0, url: nil))
            portfolioItems[id] = newSubject
            return newSubject.asObservable()
        }
        return subject.asObservable()
    }
    
    func GetFullPortfolioObs() -> Observable<[PortfolioItem]> {
        return portfolioSubject.asObservable().map {
            return $0.values.map{ subject in
                do{
                    return try subject.value()
                } catch {
                    return PortfolioItem.Default()
                }
            }
            .filter{
                $0.id == ""
            }
        }
    }
    
    func SavePortfolioItem(_ item : PortfolioItem, _ cash : CashItem){
        let operation = repo.SavePortfolioFile(item)
        if(!operation){
            print("Save failed")
            return
        }
        let newCash = repo.UpdateCash(cash)
        cashSubject.onNext(newCash)

        ConstructPortfolio()
        if(!item.HasShares()){
            portfolioItems[item.id]?.onNext(item)
        }
        
        
    }
    
    func GetCashObs() -> Observable<CashItem> {
        return cashSubject.asObservable()
    }
    
    
    private func ConstructPortfolio(){
        let files = repo.GetPorfolioFiles()
        for file in files{
            let itemOpt = portfolioItems[file.id]
            if let item = itemOpt {
                item.onNext(file)
            }
            else{
                portfolioItems[file.id] = BehaviorSubject<PortfolioItem>(value: file)
            }
        }
        portfolioSubject.onNext(portfolioItems)
    }
    
    
    
    
    
    
}
