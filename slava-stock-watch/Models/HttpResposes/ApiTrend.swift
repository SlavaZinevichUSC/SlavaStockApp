//
//  ApiTrend.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import Foundation

struct ApiTrend : ApiCallable{
    let trend : [Double]
    static func GetHttpName() -> String {
        return "trend"
    }
    
    enum outer : String, CodingKey{
        case trend
    }
    
    enum inner : String, CodingKey {
        case c
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: outer.self)
        let inner = try container.nestedContainer(keyedBy: inner.self, forKey: .trend)
        trend = try inner.decode([Double].self, forKey: .c)
    }
    
    init(_ trend : [Double]){
        self.trend = trend
    }
    
    static func Default() -> ApiTrend {
        return ApiTrend([])
    }
    
    
}
