//
//  DetailVC.swift
//  Project7
//
//  Created by Ada on 24.01.2024.
//

import UIKit
import WebKit

class DetailVC: UIViewController {
    var webView: WKWebView!
     var detailItem: Petition?

    
    //viewdidload once calisir
     override func loadView() {
         webView = WKWebView()
         view = webView
     }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
