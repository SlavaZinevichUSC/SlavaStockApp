//
//  StockNewsItemView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/28/22.
//

import SwiftUI

struct StockNewsItemView: View {
    @ObservedObject var vm : ViewModel
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(minimum: 100)), GridItem(.fixed(75))], alignment: .leading){
            Summary(vm.newsItem)
            Image(vm.newsItem)
        }
    }
    
    
    init(_ newsItem : ApiNewsItem){
        vm = ViewModel(newsItem)
    }
}

extension StockNewsItemView{
    func Summary(_ newsItem : ApiNewsItem) -> some View{
        let txt = Text("\(newsItem.source) ").bold()  + Text(Date.ElapsedFromTimestamp(newsItem.publishDate))
        return VStack(alignment: .leading){
            txt.foregroundColor(Color.gray).font(.subheadline)
            Text("\(newsItem.title)").bold()
        }
    }
    
    func Image(_ newsItem : ApiNewsItem) -> some View{
        return AsyncImage(url: URL(string: newsItem.imgUrl)){image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50, alignment: .leading)
            .cornerRadius(10)
    }
}

extension StockNewsItemView{
    class ViewModel : ObservableObject{
        @Published var newsItem : ApiNewsItem
        
        init(_ newsItem : ApiNewsItem){
            self.newsItem = newsItem
        }
    }
}

struct StockNewsItemView_Previews: PreviewProvider {
    static var previews: some View {
        StockNewsItemView(ApiNewsItem.Default())
    }
}
