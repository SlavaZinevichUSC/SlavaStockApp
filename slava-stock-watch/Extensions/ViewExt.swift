//
//  ViewExt.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/30/22.
//

import Foundation
import SwiftUI

extension View{
    func AsSection() -> some View{
        return Section{
            self
        }
    }
    
    func AsSection(_ title: String) -> some View{
        return Section(title){
            self
        }
    }
}
