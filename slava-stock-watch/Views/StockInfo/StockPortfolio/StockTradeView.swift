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
    @EnvironmentObject var containerService : ServiceContainer
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
                Text("$\(String.FormatDouble(vm.cash.money)) available to buy \(commonData.id)")
                GetButtons()
            }
        }
        .onAppear(perform: {
            vm.Activate(commonData)
        })
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
        return String.FormatDouble(shares * current)
    }
    
    private func SharesInt() -> Int{
        return Int(sharesInput) ?? 0
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
    struct BuyBottonMeta{
        let text = "Sell"
        
        func Validate(_ sharesInput: String) -> ValidatorState{
            let shares = sharesInput.AsInt(-69) //Stupid method that is a bug if the user enters -69 but fuck them anyway
            if(shares == -69){
                return ValidatorState.InvalidInput
            }
            if(shares <= 0){
                return ValidatorState.InvalidShareCountBuy
            }
            return ValidatorState.Valid
            
        }
    }
    
    struct SellButtonMeta{
        let text = "Buy"
        
        func Validate(_ sharesInput: String) -> ValidatorState{
            let shares = sharesInput.AsInt(-69) //Stupid method that is a bug if the user enters -69 but fuck them anyway
            if(shares == -69){
                return ValidatorState.InvalidInput
            }
            if(shares <= 0){
                return ValidatorState.InvalidShareCountSell
            }
            return ValidatorState.Valid
        }
    }

    enum ValidatorState{
        case Valid
        case InsufficientFunds
        case InsufficientShares
        case InvalidShareCountBuy
        case InvalidShareCountSell
        case InvalidInput
    }
}

extension StockTradeView{
    class ViewModel : ObservableObject{
        @Published var cash : CashItem
        @Published var stock : PortfolioItem
        
        init(_ cash : CashItem){
            self.cash = CashItem.Default()
            self.stock = PortfolioItem.Default()
        }
        
        func Validate(_ newValue : Character) -> Bool{
            return "0123456789".contains(newValue)
        }
        
        func Activate(_ commonData : StockCommonData){
            _ = commonData.cashObs.subscribe{data in
                self.cash = data
            }
            _ = commonData.portfolioObs.subscribe{data in
                self.stock = data
            }
        }
    }
}


struct StockTradeView_Previews: PreviewProvider {
    static var previews: some View {
        StockTradeView(CashItem.Default(), .constant(false))
    }
}
