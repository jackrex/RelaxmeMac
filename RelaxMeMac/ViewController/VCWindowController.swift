//
//  VCWindowController.swift
//  RelaxMe
//
//  Created by thrones on 2019/11/10.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa

class VCWindowController: NSWindowController, NSWindowDelegate {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(nil)
        return false
    }
}
