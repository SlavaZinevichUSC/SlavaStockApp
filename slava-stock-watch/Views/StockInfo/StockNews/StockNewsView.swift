//
//  StockNewsView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/28/22.
//

import SwiftUI

struct StockNewsView: View {
    @ObservedObject var vm : ViewModel
    @State private var isPresented = false
    @State private var selectedItem : ApiNewsItem? = nil
    var body: some View {
        VStack{
            StockNewsLeadingItem(vm.news.newsItems[0])
            Divider()
            ForEach(vm.news.newsItems[1...].prefix(5), id: \.title){item in
                StockNewsItemView(item)
                    .onTapGesture {
                        self.selectedItem = item
                    }
                Divider()

            }
            .sheet(item: $selectedItem, content: { item in
                StockNewsPopupView(selectedItem ?? ApiNewsItem.Default())
            })

            
        }
    }
    
    init(_ id : String, _ container : ServiceContainer){
        vm = ViewModel(id, container.GetHttpService())
    }
}

extension StockNewsView{
    class ViewModel : ObservableObject{
        @Published var news : ApiNews = ApiNews.Default()
        
        init(_ id : String, _ http : IHttpService){
            http.Get(id: id, completion: { data in
                self.news = data
            })
        }
    }
}

struct StockNewsView_Previews: PreviewProvider {
    static var previews: some View {
        StockNewsView("TSLA", ServiceContainer.Current())
    }
}
