//
//  WatchlistItem.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import Foundation


class WatchlistItem : IPersistent{
    let id : String
    let name : String
    let url : URL?
    
    init(_ id : String, _ name : String, _ url : URL?){
        self.id = id
        self.name = name
        self.url = url
    }
    
    func IsOnWatchlist() -> Bool{
        return self.url != nil
    }
    
    func AsOffWatchlist() -> WatchlistItem{
        return WatchlistItem(id, name, nil)
    }
    
    static func Default() -> WatchlistItem{
        return WatchlistItem("", "", nil)
    }
}
