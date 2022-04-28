//
//  StringFormatExt.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/27/22.
//

import Foundation
import SwiftUI

typealias BuildString = NSMutableAttributedString

extension String{
    func AsText() -> Text{
        return Text(self)
    }
}

extension Text{
    func Bold(_ value:String) -> Text{
        return self + Text.Bold(value)
    }
    
    func Normal(_ value:String) -> Text{
        return self + Text(value)
    }
    
    func Double(_ value:Double) -> Text{
        return self + Text(Text.FormatDouble(value))
    }
    
    func AsInfo() -> Text{
        return self.font(.caption)
    }
    
    func Space() -> Text{
        return self + Text(" ")
    }
    
    private static func FormatDouble(_ value : Double) -> String{
        return String(format: "%.2f", value)
    }
    
    static func Bold(_ value:String) -> Text{
        return Text(value).bold()
    }
}

