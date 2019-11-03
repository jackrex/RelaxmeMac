//
//  WebViewController.swift
//  RelaxMeMac
//
//  Created by jackrex on 2/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    var loadUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let myURL = URL(string: loadUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        
    }
    
}
