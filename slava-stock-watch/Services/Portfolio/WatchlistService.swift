//
//  WatchlistService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import Foundation
import CoreData
import RxSwift

class WatchlistService : IWatchlistService{
    private let manager : IWatchlistManager
    private var watchlist : Dictionary<String, BehaviorSubject<WatchlistItem>>
    private let watchlistSubject : BehaviorSubject<Dictionary<String, BehaviorSubject<WatchlistItem>>>
    
    init(_ manager : IWatchlistManager){
        self.manager = manager
        self.watchlist = Dictionary()
        watchlistSubject = BehaviorSubject(value: watchlist)
        ConstructWatchlist()
    }
    
    func SaveFile(_ item: WatchlistItem){
        _ = manager.SaveFile(id: item.id, name: item.name, url: item.url)
        ConstructWatchlist()
    }
    
    func GetWatchlist() -> RxSwift.Observable<[WatchlistItem]>{
        return watchlistSubject.asObservable().map{
            return $0.values.map{subject in
                do{
                    return try subject.value()
                } catch {
                    return WatchlistItem.Default()
                }
            }
            .filter({
                $0.IsOnWatchlist()
            })
        }
    }
    
    func GetWatchlistItem(_ id : String, name : String) -> RxSwift.Observable<WatchlistItem>{
        let itemOpt = watchlist[id]
        guard let item = itemOpt else{
            let newItem = BehaviorSubject(value : WatchlistItem(id, name, nil))
            watchlist[id] = newItem
            return newItem.asObservable()
        }
        return item.asObservable()
    }
    
    func DeleteFile(_ item : WatchlistItem){
        _ = manager.DeleteFile(url: item.url)
        watchlist[item.id]?.onNext(item.AsOffWatchlist())
        ConstructWatchlist()
        
    }
    
    func DeleteFiles(_ items : [WatchlistItem]){
        manager.DeleteFiles(urls: items.map{ return $0.url })
        for item in items{
            watchlist[item.id]?.onNext(item.AsOffWatchlist())
        }
        ConstructWatchlist()
    }
    
    func ConstructWatchlist(){
        let files = manager.GetFiles().map{
            return WatchlistItem($0.id ?? "", $0.name ?? "", $0.objectID.uriRepresentation())
            
        }
        for file in files{
            let fileOpt = watchlist[file.id]
            if let item = fileOpt{
                item.onNext(file)
            }
            else {
                watchlist[file.id] = BehaviorSubject(value : file)
            }
        }
        watchlistSubject.onNext(watchlist)
    }
    
}
