//
//  WatchlistManager.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import Foundation
import CoreData

class WatchlistManager : ManagerBase, IWatchlistManager{
    
    func SaveFile(id : String, name : String, url: URL?) -> Bool{
        let fileOpt = TryGetFileByUrl(url) as? WatchlistFile
        let file = fileOpt ?? WatchlistFile(context: container.viewContext)
        file.id = id
        file.name = name
        return super.TrySave()
    }
    
    func GetFiles() -> [WatchlistFile]{
        let req = WatchlistFile.fetchRequest()
        return ExecuteFetch(req)
    }
    
    func DeleteFile(url : URL?) -> Bool{
        return ExecuteDelete(url: url)
    }
    
    func DeleteFiles(urls : [URL?]) {
        ExecuteDeletes(urls: urls)
    }
    
}
