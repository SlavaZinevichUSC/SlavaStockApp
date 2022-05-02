//
//  ApiProfile.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

struct ApiProfile : ApiCallable{
    
    static func GetHttpName() -> String {
        return "profile"
    }
    let id : String
    let name : String
    let imgUrl : String
    
    enum CodingKeys : String, CodingKey {
        case profile
    }
    
    enum EmbeddedCodingKeys: String, CodingKey{
        case id = "ticker"
        case name 
        case imgUrl = "logo"
        case ipo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let profile = try container.nestedContainer(keyedBy: EmbeddedCodingKeys.self, forKey: .profile)
        name = try profile.decode(String.self, forKey: .name)
        id = try profile.decode(String.self, forKey: .id).uppercased()
        imgUrl = try profile.decode(String.self, forKey: .imgUrl)
    }
    
    init(_ name: String,_ id: String, _ imgUrl: String){
        self.name = name
        self.id = id
        self.imgUrl = imgUrl
    }
    static func Default() -> ApiProfile{
        return ApiProfile("", "", "")
    }
    
    
}
