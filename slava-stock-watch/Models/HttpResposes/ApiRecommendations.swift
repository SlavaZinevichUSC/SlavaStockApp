//
//  ApiRecommendations.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import Foundation


struct ApiRecommendations : ApiCallable{
    let recs : [ApiSingleRec]
    static func GetHttpName() -> String {
        return "recommendations"
    }
    
    enum CodingKeys : String, CodingKey {
        case recommendations
    }
    
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        recs = try container.decode([ApiSingleRec].self, forKey: .recommendations).reversed()
    }
    
    init(_ recs : [ApiSingleRec]){
        self.recs = recs
    }
    
    static func Default() -> ApiRecommendations {
        return ApiRecommendations([])
    }
}

struct ApiSingleRec : Decodable{
    
    let strongBuy : Int
    let buy : Int
    let hold : Int
    let sell : Int
    let strongSell : Int
    let period : String
    enum CodingKeys : String, CodingKey{
        case strongBuy
        case buy
        case hold
        case sell
        case strongSell
        case period
        
    }
}
