//
//  DateExt.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/28/22.
//

import Foundation


extension Date{
    static func FromTimestamp(_ timestamp: Int) -> String{
        let obj = Date(timeIntervalSince1970: Double(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date = formatter.string(from: obj)
        return date
    }
    
    static func ElapsedFromTimestamp(_ timestamp: Int) -> String{
        let obj = Date(timeIntervalSince1970: Double(timestamp))
        let diff = Date.now.timeIntervalSinceReferenceDate - obj.timeIntervalSinceReferenceDate
        let totalMinutes = (diff / 60).rounded()
        let hours = (totalMinutes / 60).rounded(.down)
        if(hours <= 0){
            return "\(Int(totalMinutes.rounded())) min"
        }
        let minutes = Int((totalMinutes - hours).rounded())
        return "\(Int(hours)) hr, \(Int(minutes)) min"
    }
}
