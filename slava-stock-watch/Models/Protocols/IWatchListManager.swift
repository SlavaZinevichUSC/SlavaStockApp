//
//  IWatchListManager.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import Foundation


protocol IWatchlistManager{
    func GetFiles() -> [WatchlistFile]
    func SaveFile(id : String, name : String, url: URL?) -> Bool
    func DeleteFile(url : URL?) -> Bool
    func DeleteFiles(urls : [URL?])
}
