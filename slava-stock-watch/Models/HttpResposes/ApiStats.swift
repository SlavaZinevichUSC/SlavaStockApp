//
//  ApiStats.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import Foundation

struct ApiStats : ApiCallable{
    static func GetHttpName() -> String {
        return "price"
    }
    
    let high : Double
    let low : Double
    let prevClose : Double
    let open : Double
    
    enum CodingKeys : String, CodingKey {
        case price
    }
    
    enum EmbeddedCodingKeys: String, CodingKey{
        case high = "h"
        case low = "l"
        case prevClose = "pc"
        case open = "o"
    }
    
    init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let profile = try container.nestedContainer(keyedBy: EmbeddedCodingKeys.self, forKey: .price)
        high = try profile.decode(Double.self, forKey: .high)
        low = try profile.decode(Double.self, forKey: .low)
        prevClose = try profile.decode(Double.self, forKey: .prevClose)
        open = try profile.decode(Double.self, forKey: .open)
    }
    init(_ h : Double, _ l : Double, _ p : Double, _ o : Double){
        high = h
        low = l
        prevClose = p
        open = o
    }
    
    static func Default() -> ApiStats {
        return ApiStats(420, 0, 100, 69)
    }
    
}
