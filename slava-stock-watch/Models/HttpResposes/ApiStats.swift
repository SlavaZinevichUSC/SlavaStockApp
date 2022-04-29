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
    let change : Double
    let current : Double
    
    enum CodingKeys : String, CodingKey {
        case price
    }
    
    enum EmbeddedCodingKeys: String, CodingKey{
        case high = "h"
        case low = "l"
        case prevClose = "pc"
        case open = "o"
        case change = "dp"
        case current = "c"
    }
    
    init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let profile = try container.nestedContainer(keyedBy: EmbeddedCodingKeys.self, forKey: .price)
        high = try profile.decode(Double.self, forKey: .high)
        low = try profile.decode(Double.self, forKey: .low)
        prevClose = try profile.decode(Double.self, forKey: .prevClose)
        open = try profile.decode(Double.self, forKey: .open)
        change = try profile.decode(Double.self, forKey: .change)
        current = try profile.decode(Double.self, forKey: .current)
    }
    
    init(_ h : Double, _ l : Double, _ p : Double, _ o : Double, _ c : Double, _ t : Double){
        high = h
        low = l
        prevClose = p
        open = o
        change = c
        current = t
    }
    
    static func Default() -> ApiStats {
        return ApiStats(420, 0, 100, 69, 0.69, 210)
    }
    
}
