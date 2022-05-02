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
        return self + Text.FormatDouble(value)
    }
    
    func Link(_ value : String, _ url : String) -> Text{
        let link = "[\(value)](\(url))"
        return self + Text(.init(link))
    }
    
    func Link(_ value : String) -> Text{
        let link = "[\(value)](\(value))"
        return self + Text(.init(link))
    }
    
    func AsInfo() -> Text{
        return self.font(.body)
    }
    
    func AsTitle() -> Text{
        return self.bold().font(.largeTitle)
    }
    
    func Space() -> Text{
        return self + Text(" ")
    }
    
    static func Bold(_ value:String) -> Text{
        return Text(value).bold()
    }
    
    static func Header(_ value : String) -> Text{
        return Text.Bold(value).font(.title)
    }
    
    static func ToDate(_ value : Int) -> Text{
        return Text(Date.FromTimestamp(value))
    }
    
    static func FormatDouble(_ value : Double) -> Text{
        return Text(String.FormatDouble(value))
    }
}

extension String{
    static func FormatDouble(_ value : Double) -> String{
        return String(format: "%.2f", value)
    }
    
    func AsDouble(_ fallback : Double = 0.00) -> Double{
        return Double(self) ?? fallback
    }
    
    func AsInt(_ fallback : Int = 0) -> Int{
        return Int(self) ?? fallback
    }
}

