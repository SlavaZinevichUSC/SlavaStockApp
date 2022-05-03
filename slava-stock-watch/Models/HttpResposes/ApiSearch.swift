//
//  ApiSearch.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import Foundation


struct ApiSearch : ApiCallable{
    static func GetHttpName() -> String {
        return "symbols"
    }
    
    let searchResults : [ApiSearchItem]
    
    enum CodingKeys : String, CodingKey {
        case symbols
    }
    
    enum EmbeddedKeys : String, CodingKey{
        case  result
    }
    init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let symbols = try container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .symbols)
        searchResults = try symbols.decode([ApiSearchItem].self, forKey: .result)
        
    }
    
    init(_ items : [ApiSearchItem]){
        searchResults = items
    }
    
    static func Default() -> Self {
        return ApiSearch([])
    }
    
    
}

struct ApiSearchItem : Decodable{
    let id : String
    let name : String
    
    init(_ id : String, _ name : String){
        self.id = id
        self.name = name
    }
    
    enum CodingKeys : String, CodingKey {
        case id = "symbol"
        case name = "description"
    }
    
    static func Default() -> Self{
        return ApiSearchItem("SLVS", "Slava Inc.")
    }
}
