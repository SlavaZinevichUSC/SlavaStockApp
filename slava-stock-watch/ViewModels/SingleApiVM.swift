//
//  SingleApiVM.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation


class SingleItemDynamicVM<T : ApiCallable> : ObservableObject{
    @Published var data = T.Default()
    
    func Get(_ id : String, _ http : IHttpService){
        http.Get(id: id){ data in
            self.data = data
        }
        debugPrint("Refreshed single item")
    }
}

class SingleItemVM<T : ApiCallable> : ObservableObject{
    @Published var data = T.Default()
    var hasLoaded = false;
    
    func Get(_ id : String, _ http : IHttpService){
        if(hasLoaded) { return } //SUUPER UGLY BUT VIEW KEEPS UPDATING
        http.Get(id: id){ (data : T) in
            self.data = data
            self.hasLoaded = true
        }
    }
}
