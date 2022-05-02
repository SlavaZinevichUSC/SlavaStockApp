//
//  StockTradeView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import SwiftUI
import Combine

struct StockTradeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var commonData : StockCommonData
    @State var sharesInput : String = "0"
    @State var showSuccess : Bool = false
    @Binding var showSheet : Bool
    @ObservedObject var vm : ViewModel

    private var name :  String { commonData.profile.value.name }
    var body: some View {
        NavigationView{
            VStack{
                Text("Trade \(name) shares")
                    .bold()
                    .padding(.bottom)
                HStack{
                    GetForm()
                    Text("Shares").AsTitle()
                }
                GetCalculationText()
                Spacer()
                GetButtons()
            }
        }//.offset(y: -300)
    }
    
    init(_ cash : CashItem, _ binding : Binding<Bool>){
        vm = ViewModel(cash)
        _showSheet = binding
    }
}

extension StockTradeView{
    private func GetForm() -> some View{
        return TextField("0", text: $sharesInput)
                    .keyboardType(.numberPad)
                    .onReceive(Just(sharesInput)) { newValue in
                        let filtered = newValue.filter {
                            vm.Validate($0)
                        }
                        if filtered != newValue {
                            self.sharesInput = filtered
                        }
                    }
                    .font(Font.system(size: 75))
                    .frame(width: UIScreen.screenWidth60)
    }
    
    private func GetCalculationText() -> some View{
        let current = commonData.stats.value.current
        return Text("x ").Double(current).Normal("/share = \(GetTotalValue(current))")
            .frame(alignment: .trailing)
    }
    
    private func GetTotalValue(_ current : Double) -> String{
        let shares = Double(self.sharesInput) ?? 0
        return String.FormatDouble(shares)
    }
    
    private func GetButtons() -> some View{
        return HStack{
            GetSingleButton(false)
            Spacer()
            GetSingleButton(true)
        }
        .padding()
    }
    
    private func GetSingleButton(_ isSell : Bool) -> some View{ //INCREDIBLY UGLY
        let text = isSell ? "Sell" : "Buy"
        return Button(action: {
            print("Pressed")
            self.showSuccess.toggle()
            
        }, label: {
            Text(text)
                .frame(width: UIScreen.dScreenWidth50, height : 50)
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(20)
        })
    }
}

extension StockTradeView{
    class ViewModel : ObservableObject{
        let cash : CashItem
        
        init(_ cash : CashItem){
            self.cash = cash
        }
        
        func Validate(_ newValue : Character) -> Bool{
            return "0123456789".contains(newValue)
        }
    }
}


struct StockTradeView_Previews: PreviewProvider {
    static var previews: some View {
        StockTradeView(CashItem.Default(), .constant(false))
    }
}
