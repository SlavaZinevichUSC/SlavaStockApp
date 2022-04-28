//
//  ApiSentiments.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import Foundation


struct ApiSentiments : ApiCallable{
    
    static func GetHttpName() -> String {
        return "mentions"
    }
    let redditPos : Int
    let twitterPos : Int
    let redditNeg : Int
    let twitterNeg : Int
    let redditTotal : Int
    let twitterTotal : Int
    
    enum CodingKeys : String, CodingKey {
        case mentions
    }
    
    enum EmbeddedCodingKeys: String, CodingKey{
        case reddit
        case twitter
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mentions = try container.nestedContainer(keyedBy: EmbeddedCodingKeys.self, forKey: .mentions)
        let reddit = try mentions.decode([Sentiment].self, forKey: .reddit)
        let twitter = try mentions.decode([Sentiment].self, forKey: .twitter)
        var redPos = 0
        var redNeg = 0
        for item in reddit{
            redPos += item.pos
            redNeg += item.neg
        }
        self.redditPos = redPos
        self.redditNeg = redNeg
        self.redditTotal = redPos + redNeg
        var tPos = 0
        var tNeg = 0
        for item in twitter{
            tPos += item.pos
            tNeg += item.neg
        }
        self.twitterPos = tPos
        self.twitterNeg = tNeg
        self.twitterTotal = tPos + tNeg
    }
    
    init(_ rp : Int, _ rn :Int, _ tp: Int, _ tn : Int){
        redditPos = rp
        redditNeg = rn
        redditTotal = rp + rn
        twitterPos = tp
        twitterNeg = tn
        twitterTotal = tn + tp
    }
    
    static func Default() -> ApiSentiments{
        return ApiSentiments(69, 1, 420, 100)
    }
}

extension ApiSentiments{
    struct Sentiment : Decodable{
        let pos : Int
        let neg : Int
        
        enum CodingKeys: String, CodingKey{
            case pos = "positiveMention"
            case neg = "negativeMention"
        }
    }
}

