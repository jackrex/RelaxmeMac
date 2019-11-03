//
//  Extension.swift
//  Tabbar
//
//  Created by Throns on 5/10/2018.
//  Copyright © 2018 Sunny. All rights reserved.
//

import Foundation
import Cocoa

extension String {
        
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        #if DEBUG
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
        #else
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
        #endif
    }
    func format(_ parameters: CVarArg...) -> String {
        return String(format: self, arguments: parameters)
    }
    
    func squareFormat() -> String {
        return self + Contanst.squareFormat
    }
    
    func smallAvatarFormat() -> String {
        if self.contains("lcfile.com") {
            return self + Contanst.smallAvatarFormat
        }
        return self
    }
    
    func largeAvatarFormat() -> String {
        return self + Contanst.largeAvatarFormat
    }
    
    func timelineSinglePhotoFormat() -> String {
        return self + Contanst.timelineSinglePhotoFormat
    }
    
    func timelineSplitPhotoFormat() -> String {
        return self + Contanst.timelineSplitPhotoFormat
    }
    
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    func htmlAttributed(family: String?, size: CGFloat, color: String) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #\(color) !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}
