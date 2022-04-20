//
//  MainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/19/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView{
            Form{
                SearchView()
                PortfolioView()
            }
            .navigationTitle("Slava`s stock watch")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
