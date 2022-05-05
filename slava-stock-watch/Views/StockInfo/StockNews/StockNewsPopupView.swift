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
        NavigationView{
            
            VStack(alignment: .leading){
                HStack{
                    Text.Header(newsItem.source)
                }
                Text.ToDate(newsItem.publishDate).font(.caption)
                Divider()
                Text(newsItem.title).font(.system(size: 18, weight: .bold)).padding(.bottom)
                Text(newsItem.summary).font(.body)
                Text("For more information, click ").Link("here", newsItem.url).font(.system(size: 8, weight: .light))
                HStack{
                    MakeButton("https://twitter.com/intent/tweet?url=", "Twitter")
                    MakeButton("https://www.facebook.com/sharer/sharer.php?u=", "Facebook")
                }
                Spacer()
            }
            .toolbar{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark").foregroundColor(.black)
                })
            }
        }
    }
    
    init(_ newsItem : ApiNewsItem){
        self.newsItem = newsItem
    }
    
    func MakeButton(_ url: String, _ imgName : String) -> some View{
        return Button(action: {
            if let url = URL(string: "\(url)\(newsItem.url)") {
                UIApplication.shared.open(url)
            }
        }, label: {
            Image(imgName)
                .resizable()
                .scaledToFit()
                
        }).frame(width: 50, height: 50)
    }
}

struct StockNewsPopupView_Previews: PreviewProvider {
    static var previews: some View {
        StockNewsPopupView(ApiNewsItem.Default())
    }
}
