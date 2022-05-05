//
//  StockGraphView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import SwiftUI

struct StockGraphView: View {
    @StateObject var vm = ViewModel()
    @EnvironmentObject var container : ServiceContainer
    @EnvironmentObject var commonData : StockCommonData
    var body: some View {
        if(vm.data.o.count > 1){
            HighchartsWebView(vm.GetMinScript())
                .frame(width: UIScreen.screenWidth * 1.22, height: 400, alignment: .leading)
                .offset(x: -55)
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

extension StockGraphView{
    class ViewModel : ObservableObject{
        @Published var data  : ApiChart = ApiChart.Default()
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
            _ = http.Get(id: id).subscribe{ (data : ApiChart) in
                if(data.o.count == self.data.o.count){
                    return //Im a dirty dirty cheater
                }
                self.data = data
                self.hasLoaded = true
            }
        }
        
        func GetOHLCAndVolume() -> (ohlc: String, v: String) {
            if(data.o.count < 1){
                return ("[]", "[]")
            }
            var res = "["
            var vol = "["
            for i in 0...(data.o.count - 1){
                let t = data.t[i] * 1000
                res += "[\(t), \(data.o[i]), \(data.h[i]), \(data.h[i]), \(data.l[i]), \(data.c[i])],"
                vol += "[\(t), \(data.v[i])],"
            }
            res += "]"
            vol += "]"
            return (res, vol)
        }
        
        func GetMinScript() -> String{
            let data = GetOHLCAndVolume()
            let ohlc = data.ohlc
            return  """
function Run(){
  Highcharts.chart('container', {
        rangeSelector: {
            selected: 2
        },
        title: {
            text:  'Stock Price'
        },
        yAxis: [{
              startOnTick: false,
              endOnTick: false,
              labels: {
                  align: 'right',
                  x: -3
              },
              title: {
                  text: 'OHLC'
              },
              height: '100%',
              lineWidth: 2,
              resize: {
                  enabled: true
              }
          }],

          tooltip: {
              split: true
          },

          plotOptions: {
              series: {
                  dataGrouping: {
                      units: [['week',[1]], ['month',  [1, 2, 3, 4, 6]]]
                  }
              }
          },
        series: [{
            type: undefined,
            name: 'Stock Price',
            id: 'series',
            zIndex : 2,
            data: \(ohlc),
            dataGrouping: {  units: [['week',[1]], ['month',  [1, 2, 3, 4, 6]]]}
        },
        ]
    });
}

"""
        }
        
        func GetScript() -> String {
            let data = GetOHLCAndVolume()
            let ohlc = data.ohlc
            let v = data.v
            return """
function Run(){
  Highcharts.chart('container', {
        rangeSelector: {
            selected: 2
        },
        title: {
            text:  'Stock Price'
        },
        yAxis: [{
              startOnTick: false,
              endOnTick: false,
              labels: {
                  align: 'right',
                  x: -3
              },
              title: {
                  text: 'OHLC'
              },
              height: '60%',
              lineWidth: 2,
              resize: {
                  enabled: true
              }
          }, {
              labels: {
                  align: 'right',
                  x: -3
              },
              title: {
                  text: 'Volume'
              },
              top: '65%',
              height: '35%',
              offset: 0,
              lineWidth: 2
          }],

          tooltip: {
              split: true
          },

          plotOptions: {
              series: {
                  dataGrouping: {
                      units: [['week',[1]], ['month',  [1, 2, 3, 4, 6]]]
                  }
              }
          },
        series: [{
            type: undefined,
            name: 'Stock Price',
            id: 'series',
            zIndex : 2,
            data: \(ohlc),
            dataGrouping: {  units: [['week',[1]], ['month',  [1, 2, 3, 4, 6]]]}
        },{
            type: 'column',
            name: 'Volume',
            data: \(v),
            id:'volume',
            yAxis: 1,
            dataGrouping: {  units: [['week',[1]], ['month',  [1, 2, 3, 4, 6]]]
            }
        }, {
            type: 'vbp',
            linkedTo: 'series',
            params: {
                volumeSeriesID: 'volume'
            },
            dataLabels: {enabled: false},
            zoneLines: {  enabled: false}
        }, {
            type: 'sma',
            linkedTo: 'series',
            zIndex: 1,
            marker: {enabled: false }
        }
        ]
    });
}

"""
        }
    }
}

struct StockGraphView_Previews: PreviewProvider {
    static var previews: some View {
        StockGraphView()
    }
}
