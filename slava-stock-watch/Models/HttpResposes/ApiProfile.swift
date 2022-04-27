//
//  ApiProfile.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/20/22.
//

struct ApiProfile : ApiCallable{
    mutating func Update(with: ApiProfile) {
        self.name = with.name
    }
    
    
    static func GetHttpName() -> String {
        return "profile"
    }
    var id : String
    var name : String
    var imgUrl : String
    
    enum CodingKeys : String, CodingKey {
        case profile
    }
    
    enum EmbeddedCodingKeys: String, CodingKey{
        case id = "ticker"
        case name 
        case imgUrl = "logo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let profile = try container.nestedContainer(keyedBy: EmbeddedCodingKeys.self, forKey: .profile)
        name = try profile.decode(String.self, forKey: .name)
        id = try profile.decode(String.self, forKey: .id)
        imgUrl = try profile.decode(String.self, forKey: .imgUrl)
    }
    
    init(name: String, id: String, imgUrl: String){
        self.name = name
        self.id = id
        self.imgUrl = imgUrl
    }
    static func Default() -> ApiProfile{
        return ApiProfile(name: "", id: "", imgUrl: "")
    }
    
    
}
