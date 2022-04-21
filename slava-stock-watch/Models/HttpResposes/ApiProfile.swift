//
//  ApiProfile.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

struct ApiProfile : Decodable{
    let id : String
    let name : String
    
    enum CodingKeys: String, CodingKey{
        case id = "ticker"
        case name = "name"
    }
    
    static func Default() -> ApiProfile{
        return ApiProfile(id: "", name: "")
    }
}
