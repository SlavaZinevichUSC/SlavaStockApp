//
//  SingleApiVM.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation



class SingleItemVM<T : ApiCallable> : ObservableObject{
    @Published var data  : T = T.Default()
    @Published var hasLoaded : Bool = false;
    
    func Get(_ commonData : StockCommonData, _ http : IHttpService){
        if(hasLoaded) { return } //SUUPER UGLY BUT VIEW KEEPS UPDATING
        _ = commonData.profile.observable.subscribe{profile in
            self.HttpGet(profile.id, http)
        }
       
    }
    
    func HttpGet(_ id : String, _ http : IHttpService) {
        _ = http.Get(id: id).subscribe{ (data : T) in
            self.data = data
            self.hasLoaded = true
        }
    }
}
