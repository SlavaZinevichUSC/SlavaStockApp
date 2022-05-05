//
//  ApiPeers.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import Foundation

struct ApiPeers : ApiCallable{
    let peers : [String]
    static func GetHttpName() -> String {
        return "peers"
    }
    
    enum OuterKey : String, CodingKey{
        case peers
    }
    
    init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: OuterKey.self)
        peers = try container.decode([String].self, forKey: .peers)
    }
    
    init(_ peers : [String]){
        self.peers = peers
    }

    static func Default() -> ApiPeers {
        return ApiPeers([])
    }
}

