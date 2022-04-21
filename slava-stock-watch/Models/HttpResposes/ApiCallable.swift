//
//  ApiCallable.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 4/21/22.
//
import Foundation

protocol ApiCallable : Decodable{
    var HttpName : String { get }
    static func GetHttpName() -> String
    static func Default() -> Self
}
