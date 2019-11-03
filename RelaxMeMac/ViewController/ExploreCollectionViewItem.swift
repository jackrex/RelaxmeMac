//
//  ExploreCollectionViewItem.swift
//  RelaxMeMac
//
//  Created by jackrex on 3/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa

class ExploreCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var cellTextLabel: NSTextField!
    
    @IBOutlet weak var cellBottomView: NSView!
    @IBOutlet weak var cellImageView: NSImageView!
    override func viewDidLoad() {
       super.viewDidLoad()
       view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        
        cellBottomView.layer?.backgroundColor = NSColor.purple.cgColor
     }
    
    
    @IBAction func playAction(_ sender: Any) {
    
    
    }
    
    
}
