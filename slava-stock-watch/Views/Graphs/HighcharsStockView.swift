//
//  HighcharsStockView.swift
//  slava-stock-watch
//
//  Created by Slava Zinevich on 5/4/22.
//

import Foundation
import SwiftUI
import WebKit

final class HighchartsWebView : UIViewRepresentable{
    let htmlName = "index2"
    let highchartsScript =  """
    var script = document.createElement('script');
    script.src = 'https://code.highcharts.com/highcharts.js';
    script.type = 'text/javascript';
    """
    private let defulatScript = """
                document.body.innerHTML ="hello from script"
                """
    private let webView : WKWebView
    
    init(_ script : String){
        let wkScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)

        let controller = WKUserContentController()
        controller.addUserScript(wkScript)
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        webView = WKWebView(frame: .zero, configuration: config)
    }
    
    func ToScript(_ script : String) -> WKUserScript{
        WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        webView.load(htmlName)
    }
}

extension WKWebView{
    func load(_ htmlFileName : String){
        guard let filepath = Bundle.main.path(forResource: htmlFileName, ofType: "html") else{
            return print("Could not find html file")
        }
        do {
            let htmlString = try String(contentsOfFile: filepath, encoding:  .utf8)
            loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: filepath))
        } catch {
            return print("Could not load html")
        }
        
    }
}
