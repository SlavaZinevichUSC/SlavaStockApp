//
//  StockTradeSuccessView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/2/22.
//

import SwiftUI

struct StockTradeSuccessView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var commonData : StockCommonData
    private let shareInput : String
    @Binding var binding : Bool

    var body: some View {
        ZStack{
            Color.green
            VStack{
                Spacer()
                Text("Congratulations!").font(.headline).foregroundColor(Color.white).padding()
                Text("You successfully traded \(shareInput) shares of \(commonData.id)").foregroundColor(Color.white)
                Spacer()
                Button(action: {
                    binding.toggle()
                }, label: {
                    Text("Done")
                    
                    .frame(width: UIScreen.screenWidth75, height : 50)
                    .foregroundColor(.green)
                    .background(.white)
                    .cornerRadius(20)
                })
                .padding()
            }
            .background(Color.green.ignoresSafeArea())
        }.ignoresSafeArea()
    }
    
    init(_ shareInput : String, _ binding : Binding<Bool>){
        self.shareInput = shareInput
        self._binding = binding
    }
}

struct StockTradeSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        StockTradeSuccessView("69", .constant(false))
    }
}
