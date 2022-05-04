//
//  FinhubView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/3/22.
//

import SwiftUI

struct FinhubView: View {
    var body: some View {
        HStack{
            Spacer()
            Link("Powered by finhub.io", destination: URL(string: "https://www.finhub.io")!)
                    .font(.footnote).foregroundColor(.gray).frame(alignment: .center)
            Spacer()
        }
    }
}

struct FinhubView_Previews: PreviewProvider {
    static var previews: some View {
        FinhubView()
    }
}
