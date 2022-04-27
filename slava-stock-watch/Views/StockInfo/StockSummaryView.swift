//
//  StockSummaryView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/21/22.
//

import SwiftUI

struct StockSummaryView: View {
    @ObservedObject private var vm : ViewModel
    private let id : String
    var body: some View {
        Section{
            HStack(){
                VStack(alignment: .trailing){
                    Text("\(vm.profile.name)")
                    Text("\(vm.profile.id)")
                }
                Spacer()
                AsyncImage(url: URL(string: vm.profile.imgUrl))
                    .frame(maxWidth:40, maxHeight: 40)
            }
        }.frame(minHeight: 100)
    }
       

    
    
    init(_ id: String, factory : ServiceFactory){
        self.id = id
        self.vm = ViewModel(id: id, http: factory.GetHttpService())
    }
    
}

extension StockSummaryView{
    class ViewModel : ObservableObject{
        private let id : String
        private var http : IHttpService
        @Published var profile : ApiProfile
        init(id: String, http : IHttpService){
            self.id = id
            self.http = http
            self.profile = ApiProfile.Default()
            http.Get(id: id, completion: { data in
                self.OnCompletion(profile: data)
            })
        }
        
        func OnCompletion(profile : ApiProfile){
            self.profile = profile
        }
        
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func load(url: String){
        if let url = URL(string: url){
            return load(url: url)
        }
    }
}

struct StockSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        StockSummaryView("TSLA", factory: ServiceFactory())
    }
}
