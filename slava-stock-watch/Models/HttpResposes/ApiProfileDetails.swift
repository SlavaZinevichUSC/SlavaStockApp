//
//  ApiProfileDetails.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import Foundation

struct ApiProfileDetails : ApiCallable{
    
    static func GetHttpName() -> String {
        return "profile"
    }
    let webUrl : String
    let industry : String
    let ipo : String
    
    enum CodingKeys : String, CodingKey {
        case profile
    }
    
    enum EmbeddedCodingKeys: String, CodingKey{
        case webUrl = "weburl"
        case industry = "finnhubIndustry"
        case ipo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let profile = try container.nestedContainer(keyedBy: EmbeddedCodingKeys.self, forKey: .profile)
        ipo = try profile.decode(String.self, forKey: .ipo)
        industry = try profile.decode(String.self, forKey: .industry)
        webUrl = try profile.decode(String.self, forKey: .webUrl)
    }
    
    init(_ ipo: String,_ industry: String, _ webUrl: String){
        self.ipo = ipo
        self.industry = industry
        self.webUrl = webUrl
    }
    static func Default() -> ApiProfileDetails{
        return ApiProfileDetails("", "", "")
    }
    
    
}

