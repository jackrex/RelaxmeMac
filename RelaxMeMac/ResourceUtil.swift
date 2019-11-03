//
//  ResourceUtil.swift
//  RelaxMeMac
//
//  Created by jackrex on 2/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa

class ResourceUtil: NSObject {
    
    public static func appName() -> String {
         return "CFBundleDisplayName".localized()

     }
     
     public static func appVersion() ->String {
         if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
             let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
             return text + " Build  #" + build!
         }
         return "1.0.0"
     }
     
     public static func shortVersion() -> String {
         if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
             return text
         }
         return "1.0.0"
     }
}
