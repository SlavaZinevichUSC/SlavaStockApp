//
//  StockTradeView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/1/22.
//

import SwiftUI
import Combine
import AlertToast

struct StockTradeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var commonData : StockCommonData
    @EnvironmentObject var containerService : ServiceContainer
    @State var sharesInput : String = ""
    @State var showSuccess : Bool = false
    @State var showToast : Bool = false
    @State var validation : ValidatorState = ValidatorState.InvalidInput
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
                    .font(.caption)
                GetButtons()
            }
            
        }
        .onAppear(perform: {
            vm.Activate(commonData)
        })
        
        .toast(isPresenting: $showToast, duration: 5, tapToDismiss: true){
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "\(validation)", style: AlertToast.AlertStyle.style(backgroundColor: Color.gray, titleColor: Color.white))
        }
        .sheet(isPresented: $showSuccess){
            StockTradeSuccessView(sharesInput, $showSuccess)
                .background(Color.green)
        }
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
        return Text("x ").Double(current).Normal("/share = \(String.FormatDouble(GetTotalValue(current)))")
            .frame(alignment: .trailing)
    }
    
    private func GetTotalValue(_ current : Double) -> Double{
        let shares = Double(self.sharesInput) ?? 0
        return shares * current
    }
    
    private func SharesInt() -> Int{
        return Int(sharesInput) ?? 0
    }
    
    private func GetButtons() -> some View{
        return HStack{
            GetSingleButton(vm.GetButtonMeta(false))
            Spacer()
            GetSingleButton(vm.GetButtonMeta(true))
        }
        .padding()
    }
    
    private func GetSingleButton(_ meta : ButtonMeta) -> some View{ //INCREDIBLY UGLY
        return Button(action: {
            print("Pressed")
            validation = meta.Validate(sharesInput, GetTotalValue(commonData.stats.value.current))
            if(validation != ValidatorState.Valid){
                showToast.toggle()
            }
            else{
                self.showSuccess.toggle()
                vm.PerformTransaction(containerService, commonData, sharesInput, meta)
            }
            
        }, label: {
            Text(meta.text)
                .frame(width: UIScreen.dScreenWidth50, height : 50)
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(20)
        })
    }
}

extension StockTradeView{
    struct ButtonMeta{
        let text : String
        let mult : Double
        let Validate : (String, Double) -> ValidatorState
        init(_ text : String, _ mult : Double, _ validator : @escaping (String, Double) -> ValidatorState){
            self.mult = mult
            self.text = text
            self.Validate = validator
        }
    }

    enum ValidatorState : CustomStringConvertible{
        case Valid
        case InsufficientFunds
        case InsufficientShares
        case InvalidShareCountBuy
        case InvalidShareCountSell
        case InvalidInput
        
        var description : String {
            switch self{
            case .Valid: return "Valid"
            case .InsufficientShares: return "Not enough shares to sell"
            case .InsufficientFunds: return "Not enough money to buy"
            case .InvalidShareCountSell: return "Cannot sell non-positive shares"
            case .InvalidShareCountBuy: return "Cannot buy non-positive shares"
            case .InvalidInput: return "Please enter valid amount"
            }
        }
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
        
        func PerformTransaction(_ container : ServiceContainer,
                                _ commonData : StockCommonData,
                                _ shareInput : String, _ meta : ButtonMeta){
            let shares = shareInput.AsInt()
            let portfolio = container.GetPortfolioDataService()
            let newShares = stock.shares + Int(meta.mult) * shares
            let cost = Double(shares) * commonData.stats.value.current
            let newAvg = meta.mult < 0 ? stock.avgPrice :
            Double(stock.avgPrice * Double(stock.shares) + cost) / Double(newShares)
            
            let newItem = stock.With(avgPrice: newAvg, shares: newShares)
            let newMoney = cash.Adjust(-meta.mult * cost)
            portfolio.SavePortfolioItem(newItem, newMoney)
        }
        
        func ValidateBuy(_ shareInput : String, _ totalValue : Double) -> ValidatorState{
            let shares = shareInput.AsInt(-69) //Stupid method that is a bug if the user enters -69 but fuck them anyway
            if(shares == -69){
                return ValidatorState.InvalidInput
            }
            if(shares <= 0){
                return ValidatorState.InvalidShareCountBuy
            }
            if(totalValue > cash.money){
                return ValidatorState.InsufficientFunds
            }
            return ValidatorState.Valid
        }
        
        func ValidateSell(_ sharesInput: String, _ totalValue : Double) -> ValidatorState{ //suuper ugly
            let shares = sharesInput.AsInt(-69) //Stupid method that is a bug if the user enters -69 but fuck them anyway
            if(shares == -69){
                return ValidatorState.InvalidInput
            }
            if(shares <= 0){
                return ValidatorState.InvalidShareCountSell
            }
            if(shares > stock.shares){
                return ValidatorState.InsufficientShares
            }
            return ValidatorState.Valid
        }
        
        func GetButtonMeta(_ isSell : Bool) -> ButtonMeta{
            return isSell ? ButtonMeta("Sell", -1, ValidateSell) : ButtonMeta("Buy", 1, ValidateBuy)
        }
    }
}


struct StockTradeView_Previews: PreviewProvider {
    static var previews: some View {
        StockTradeView(CashItem.Default(), .constant(false))
    }
}
