//
//  AboutViewController.swift
//  RelaxMeMac
//
//  Created by jackrex on 2/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa

enum SettingType {
    case term
    case privacy
}

class AboutViewController: NSViewController {

    var settingType: SettingType!
    let supportUrls = ["https://calmzen.leanapp.cn/tos" ,"https://calmzen.leanapp.cn/privacy"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    @IBAction func privacyAction(_ sender: Any) {
        
        if let board = storyboard {
            let webViewVC = board.instantiateController(withIdentifier: "WebViewController") as! WebViewController
            webViewVC.loadUrl = supportUrls[1]
            webViewVC.title = "Privacy"
            self.presentAsModalWindow(webViewVC)
        }
        
        
    }
    
    
    @IBAction func termsAction(_ sender: Any) {
        
        if let board = storyboard {
            let webViewVC = board.instantiateController(withIdentifier: "WebViewController") as! WebViewController
            webViewVC.loadUrl = supportUrls[0]
            webViewVC.title = "Terms"
            self.presentAsModalWindow(webViewVC)

               }
    }
    
}
