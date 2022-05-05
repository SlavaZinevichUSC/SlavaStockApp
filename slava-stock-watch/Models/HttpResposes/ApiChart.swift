//
//  ApiChart.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import Foundation


struct ApiChart : ApiCallable{
    static func GetHttpName() -> String {
        "charts"
    }
    let o : [Double]
    let h : [Double]
    let l : [Double]
    let c : [Double]
    let t : [Double]
    let v : [Double]

    
    enum CodingKeys : String, CodingKey{
        case o
        case h
        case l
        case c
        case t
        case v
    }
    
    enum InitialKey : String, CodingKey{
        case charts
    }
    
    init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: InitialKey.self)
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .charts)
        o = try data.decode([Double].self, forKey: .o)
        h = try data.decode([Double].self, forKey: .h)
        l = try data.decode([Double].self, forKey: .l)
        c = try data.decode([Double].self, forKey: .c)
        t = try data.decode([Double].self, forKey: .t)
        v = try data.decode([Double].self, forKey: .v)

    }
    init(){
        o = []
        h = []
        l = []
        c = []
        t = []
        v = []
    }
    static func Default() -> ApiChart {
        return ApiChart()
    }
    
    
}
