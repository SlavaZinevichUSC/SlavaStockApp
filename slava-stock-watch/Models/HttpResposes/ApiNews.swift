//
//  ApiNews.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import Foundation


struct ApiNews : ApiCallable {
   
    let newsItems : [ApiNewsItem]
    
    enum CodingKeys : String, CodingKey {
        case news
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        newsItems = try container.decode([ApiNewsItem].self, forKey: .news)
    }
    
    init(_ items : [ApiNewsItem]){
        newsItems = items
    }
    
    static func Default() -> ApiNews {
        let items : [ApiNewsItem] = [ApiNewsItem.Default()]
        return ApiNews(items)
    }
    
    static func GetHttpName() -> String {
        "news"
    }
    
    
}
struct ApiNewsItem : Decodable, Identifiable{
    var id = UUID()
    
    let imgUrl : String
    let url : String
    let title : String
    let source : String
    let publishDate : Int
    let summary : String
    
    enum CodingKeys : String, CodingKey{
        case imgUrl = "image"
        case title = "headline"
        case publishDate = "datetime"
        case url
        case source
        case summary
    }
        
    static func Default() -> ApiNewsItem{
        return ApiNewsItem(imgUrl: "", url: "", title: "", source: "", publishDate: 0, summary: "")
    }
}
