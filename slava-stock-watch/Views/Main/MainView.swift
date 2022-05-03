//
//  MainView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/19/22.
//

import SwiftUI

struct MainView: View {
    @State var isSearching = false
    var body: some View {
        NavigationView{
            Group{
                Section{
                    SearchView()
                }
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
