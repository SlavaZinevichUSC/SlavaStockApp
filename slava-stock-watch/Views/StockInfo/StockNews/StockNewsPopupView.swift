//
//  StockNewsPopupView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/28/22.
//

import SwiftUI

struct StockNewsPopupView: View {
    @Environment(\.presentationMode) var presentationMode
    private var newsItem : ApiNewsItem
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text.Header(newsItem.source)
                /*Spacer()
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                    .clipShape(Circle())*/
            }
            Text.ToDate(newsItem.publishDate).font(.caption)
            Divider()
            Text(newsItem.title).font(.system(size: 18, weight: .bold)).padding(.bottom)
            Text(newsItem.summary).font(.body)
            Text("For more information, click ").Link("here", newsItem.url).font(.system(size: 8, weight: .light))
        }.padding()
    }
    
    init(_ newsItem : ApiNewsItem){
        self.newsItem = newsItem
    }
}

struct StockNewsPopupView_Previews: PreviewProvider {
    static var previews: some View {
        StockNewsPopupView(ApiNewsItem.Default())
    }
}