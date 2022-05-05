//
//  StockEpsView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import SwiftUI

struct StockEpsView: View {
    @StateObject var vm = ViewModel()
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    var body: some View {
        if(vm.data.earnings.count > 1){
            HighchartsWebView(vm.GetScript())
                .frame(width: UIScreen.screenWidth, height: 400, alignment: .leading)
                .onAppear(perform: {
                    vm.Activate(commonData, container.GetHttpService())
                    UITableView.appearance().isScrollEnabled = false
                })
        }
        else {
            HighchartsWebView(vm.GetScript())
                .frame(width: UIScreen.screenWidth, height: 400, alignment: .leading)
                .onAppear(perform: {
                    vm.Activate(commonData, container.GetHttpService())
                    UITableView.appearance().isScrollEnabled = false
                })
        }
       
    }
}

extension StockEpsView{
        class ViewModel : ObservableObject{
        @Published var data  : ApiEarnings = ApiEarnings.Default()
        @Published var hasLoaded : Bool = false;
        
        func Activate(_ commonData : StockCommonData, _ http : IHttpService){
            Get(commonData, http)
        }
        
        func Get(_ commonData : StockCommonData, _ http : IHttpService){
            if(hasLoaded) { return } //SUUPER UGLY BUT VIEW KEEPS UPDATING
            _ = commonData.profile.observable.subscribe{profile in
                self.HttpGet(profile.id, http)
            }
        }
        
        func HttpGet(_ id : String, _ http : IHttpService) {
            _ = http.Get(id: id).subscribe{ (data : ApiEarnings) in
                if(data.earnings.count == self.data.earnings.count){
                    return //Im a dirty dirty cheater
                }
                self.data = data
                self.hasLoaded = true
            }
        }
            
            func GetCategories() -> String{
                let result =  "[ " + data.earnings.reduce("", {(res, val) in
                    return res + " '\(val.period)',"
                }) + "]"
                
                return result
            }
            
            func GetSeries() -> String{
                let actual = "[" + data.earnings.reduce("", { (res, val) in
                    return res + " \(val.actual), "
                }) + "]"
                let estimate = "[" + data.earnings.reduce("", { (res, val) in
                    return res + " \(val.estimate), "
                }) + "]"
                return "{type:undefined, name:'Actual', data: \(actual)},\n"
                    + "{type:undefined, name:'Estimate', data: \(estimate)},\n"
            }
        
        func GetScript() -> String {
            return """
function Run(){
          Highcharts.chart('container', {
              chart:
              {
                    type: 'spline'
              },
              title: {text: 'Historical Eps Suprises'},
              xAxis: {categories:  \(GetCategories())},
              series: [\(GetSeries())],
            });
        }
"""
        }
    }
}

struct StockEpsView_Previews: PreviewProvider {
    static var previews: some View {
        StockEpsView()
    }
}
