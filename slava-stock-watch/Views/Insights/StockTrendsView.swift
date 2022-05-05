//
//  StockTrendsView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import SwiftUI

struct StockTrendsView: View {
    @StateObject var vm : ViewModel = ViewModel()
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    
    var body: some View {
        if(vm.data.recs.count > 1){ //Im a diry cheater
            HighchartsWebView(GetScript())
                .frame(width: UIScreen.screenWidth, height: 400, alignment: .leading)
                .onAppear(perform: {
                    vm.Activate(commonData, container.GetHttpService())
                    UITableView.appearance().isScrollEnabled = false
                })
        }
        else {
            HighchartsWebView(GetScript())
                .frame(width: UIScreen.screenWidth, height: 400, alignment: .leading)
                .onAppear(perform: {
                    vm.Activate(commonData, container.GetHttpService())
                    UITableView.appearance().isScrollEnabled = false

                })
        }
}
}

struct StockTrendsView_Previews: PreviewProvider {
    static var previews: some View {
        StockTrendsView()
    }
}

extension StockTrendsView{
    
    class ViewModel : ObservableObject{
        
        @Published var data  : ApiRecommendations = ApiRecommendations.Default()
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
            _ = http.Get(id: id).subscribe{ (data : ApiRecommendations) in
                if(data.recs.count == self.data.recs.count){
                    return //im a cheater what are you gonna do about it
                }
                self.data = data
                self.hasLoaded = true
            }
        }
        
        func GetXAxis() -> String {
            return "[" + data.recs.reduce("", { (res, val) in
                return res + " '\(val.period)', "
            }) + "]"
        }
        
        func GetSeries() -> String {
            let sb = GetSingleSeries(data.recs.reduce("[", { (res, val) in
                return res + String(val.strongBuy) + ","
            }) + "]", "StrongBuy")
            let b = GetSingleSeries(data.recs.reduce("[", { (res, val) in
                return res + String(val.buy) + ","
            }) + "]", "Buy")
            let h = GetSingleSeries(data.recs.reduce("[", { (res, val) in
                return res + String(val.hold) + ","
            }) + "]", "Hold")
            let s = GetSingleSeries(data.recs.reduce("[", { (res, val) in
                return res + String(val.sell) + ","
            }) + "]", "Buy")
            let ss = GetSingleSeries(data.recs.reduce("[", { (res, val) in
                return res + String(val.strongSell) + ","
            }) + "]", "Buy")
            return sb + b + h + s + ss
        }
        
        func GetSingleSeries(_ embed : String, _ name :String) -> String{
            return "{type: 'column', name: '\(name)', data: \(embed)}, \n"
        }
    }
}


extension StockTrendsView{
    
    
    func GetScript() -> String{
        return """
                            function Run(){
                              Highcharts.chart('container', {
                              chart: {type: 'column'},
                              title: {text: 'Recommendation trends'},
                              xAxis: {categories: \(vm.GetXAxis())},
                              yAxis: {
                                  min: 0,
                                  title: {  text: 'Recommendations'},
                                  stackLabels: {
                                    enabled: true,
                                    style: {
                                        fontWeight: 'bold',
                                        color:  'gray'
                              }}},
                              legend: {
                                  align: 'right',
                                  x: -30,
                                  verticalAlign: 'top',
                                  y: 25,
                                  floating: true,
                                  backgroundColor: 'white',
                                  borderColor: '#CCC',
                                  borderWidth: 1,
                                  shadow: false
                              },
                              tooltip: {
                                  headerFormat: '<b>{point.x}</b><br/>',
                                  pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
                              },
                              plotOptions: {
                                  column: {
                                      stacking: 'normal',
                                      dataLabels: {  enabled: true }
                                  },
                              },
                              series: [
                                \(vm.GetSeries())
                              ]
                              });
                            }
            """
    }
}
