//
//  VCWindowController.swift
//  RelaxMe
//
//  Created by thrones on 2019/11/10.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa

class VCWindowController: NSWindowController, NSWindowDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("handleReOpen"), object: nil, queue: nil) { (_) in
            self.window?.makeKeyAndOrderFront(self)
        }
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
    }
// https://blog.csdn.net/lovechris00/article/details/78143104
    func windowShouldClose(_ sender: NSWindow) -> Bool {
//        NSApp.hide(nil)
        return true
    }
}
