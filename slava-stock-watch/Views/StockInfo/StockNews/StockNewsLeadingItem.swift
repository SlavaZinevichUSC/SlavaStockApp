//
//  StockNewsLeadingItem.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/29/22.
//

import SwiftUI

struct StockNewsLeadingItem: View {
    private let newsItem : ApiNewsItem
    var body: some View {
        VStack{
            Image(newsItem)
            Summary(newsItem)
        }
    }
    
    init(_ newsItem: ApiNewsItem){
        self.newsItem = newsItem
    }
}

extension StockNewsLeadingItem{
    func Image(_ newsItem : ApiNewsItem) -> some View{
        return AsyncImage(url: URL(string: newsItem.imgUrl)){image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(height: 200)
            .cornerRadius(10)
    }
    
    func Summary(_ newsItem : ApiNewsItem) -> some View{
        let txt = Text("\(newsItem.source) ").bold()  + Text(Date.ElapsedFromTimestamp(newsItem.publishDate))
        return VStack(alignment: .leading){
            txt.foregroundColor(Color.gray).font(.subheadline)
            Text("\(newsItem.title)").bold()
        }
    } //Super ugly duplication but who gives a fuck
}

struct StockNewsLeadingItem_Previews: PreviewProvider {
    static var previews: some View {
        StockNewsLeadingItem(ApiNewsItem.Default())
    }
}
