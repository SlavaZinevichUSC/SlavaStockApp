//
//  ApiEarnings.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import Foundation


struct ApiEarnings : ApiCallable{
    let earnings : [ApiSingleEarnings]
    static func GetHttpName() -> String {
        return "earnings"
    }
    
    enum CodingKeys : String, CodingKey{
        case earnings
    }
    
    init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        earnings = try container.decode([ApiSingleEarnings].self, forKey: .earnings).reversed()

    }
    
    init(_ earnings : [ApiSingleEarnings]){
        self.earnings = earnings
    }
    
    static func Default() -> Self {
        return ApiEarnings([])
    }
}


struct ApiSingleEarnings : Decodable{
    let actual : Double
    let estimate : Double
    let period : String
    
    enum CodingKeys : String, CodingKey{
        case actual
        case estimate
        case period
    }
}
