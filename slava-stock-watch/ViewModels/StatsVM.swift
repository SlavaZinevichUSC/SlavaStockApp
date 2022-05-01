//
//  StatsVM.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation
import RxSwift

class StatsVM : ObservableObject{
    @Published var stats : ApiStats = ApiStats.Default()
    
    func Subscribe(_ sub : Observable<ApiStats>){
        _ = sub.subscribe{ data in
            self.stats = data
        }
    }
}
