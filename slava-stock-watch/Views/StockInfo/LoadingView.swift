//
//  LoadingView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/2/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(3)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
