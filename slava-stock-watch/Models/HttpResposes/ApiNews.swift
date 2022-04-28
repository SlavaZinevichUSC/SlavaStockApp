//
//  ApiNews.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import Foundation


struct ApiNews : ApiCallable {
    static func Default() -> ApiNews {
        return ApiNews(newsItems: [])
    }
    
    static func GetHttpName() -> String {
        "news"
    }
    
    
    let newsItems : [ApiNewsItem]
    
    enum CodingKeys : String, CodingKey {
        case news
    }
    enum EmbedCodingKeys : String, CodingKeys{
        case 
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        newsItems = container.decode([ApiNewsItem].self, .newsItems)

    }
}
struct ApiNewsItem : Decodable{
    let imgUrl : String
    let url : String
    let title : String
    let source : String
    let publishDate : String
    let summary : String
        
}
