//
//  MainSearchView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import SwiftUI

struct MainSearchView: View {
    private let searchList : ApiSearch
    @EnvironmentObject var container : ServiceContainer
    var body: some View{
        Section{
            List{
                ForEach(searchList.searchResults.prefix(5), id: \.id){item in
                    NavigationLink(destination: StockMainView(item)){
                        SearchItemView(item)
                    }
                }
            }
            .foregroundColor(.gray)
        }
    }
    
    init(_ searchList : ApiSearch){
        self.searchList = searchList
    }
}

extension MainSearchView{
    struct SearchItemView : View{
        @ObservedObject var vm : ItemVM
        var body: some View{
            VStack(alignment: .leading, spacing: 2){
                Text.Bold(vm.item.name).foregroundColor(.black)
                Text("\(vm.item.id)").foregroundColor(.black)
            }
            .padding()
            .frame(width: UIScreen.screenWidth, height: 50, alignment: .leading)
        }
        
        init(_ item : ApiSearchItem){
            self.vm = ItemVM(item)
        }
    }
    
    class ItemVM : ObservableObject{
        @Published var item : ApiSearchItem
        
        init(_ item : ApiSearchItem){
            self.item = item
        }
    }
}

struct MainSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MainSearchView(ApiSearch.Default())
    }
}
