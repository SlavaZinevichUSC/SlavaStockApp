//
//  MainDateView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/2/22.
//

import SwiftUI

struct MainDateView: View {
    @ObservedObject var vm : ViewModel = ViewModel()
    var body: some View {
        Text(vm.date.ToDisplay()).font(.headline).foregroundColor(.gray).padding()
    }
}

extension MainDateView{
    class ViewModel : ObservableObject{
        @Published var date : Date
        init(){
            date = Date.now
        }
    }
}

struct MainDateView_Previews: PreviewProvider {
    static var previews: some View {
        MainDateView()
    }
}
