//
//  ApiSearch.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import Foundation


//TODO APISEARCH

struct ApiSearchItem : Decodable{
    let id : String
    let name : String
    
    init(_ id : String, _ name : String){
        self.id = id
        self.name = name
    }
    
    static func Default() -> Self{
        return ApiSearchItem("SLVS", "Slava Inc.")
    }
}
