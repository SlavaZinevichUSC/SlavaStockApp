//
//  ContentView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/19/22.
//

import SwiftUI

struct ContentView: View {
    private let factory: ServiceFactory
    var body: some View {
        Group{
            MainView()
                .environmentObject(factory)
        }
    }
    
    init(){
        factory = ServiceFactory(PortfolioManager())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
