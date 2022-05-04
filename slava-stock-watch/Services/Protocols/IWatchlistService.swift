//
//  IWatchlistService.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import Foundation
import RxSwift

protocol IWatchlistService{
    func SaveFile(_ item: WatchlistItem)
    func GetWatchlist() -> RxSwift.Observable<[WatchlistItem]>
    func DeleteFile(_ item : WatchlistItem)
    func DeleteFiles(_ items : [WatchlistItem])
    func GetWatchlistItem(_ id : String, name : String) -> RxSwift.Observable<WatchlistItem>
}
