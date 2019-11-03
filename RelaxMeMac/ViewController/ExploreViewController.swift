//
//  ExploreViewController.swift
//  RelaxMeMac
//
//  Created by jackrex on 2/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import SDWebImage
import AVFoundation


class ExploreViewController: NSViewController {
    
    @IBOutlet weak var indicatorView: NSProgressIndicator!
    @IBOutlet weak var retryBtn: NSButton!
    @IBOutlet weak var exploreCollectionView: NSCollectionView!
    
    var data :[TVListData]!
    var aid: String!
    var titleText: String!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    self.indicatorView.startAnimation(nil)
    self.getAudioList()
    self.retryBtn.isHidden = true

    }
      
    func getAudioList() -> Void {
        HttpApi.exploreList { (data, success) in
            if success {
                let jsonDecoder = JSONDecoder()
                let model = try! jsonDecoder.decode(TVMainData.self, from: data)
                self.data = model.data
                // decrypt
                self.exploreCollectionView.reloadData()
                self.indicatorView.isHidden = true
            }else {
                self.indicatorView.isHidden = true
                self.retryBtn.isHidden = false
            }
          
            
        }
    }
    
    
    @IBAction func retryAction(_ sender: Any) {
        self.retryBtn.isHidden = true
        self.getAudioList()
        self.indicatorView.isHidden = false

    }
    
    
}

extension ExploreViewController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        collectionView.deselectItems(at: indexPaths)
        guard let indexPath = indexPaths.first else {return}
        guard let item = collectionView.item(at: indexPath) else {return}
        
        let cData = self.data![indexPath.section].detail
        let detailData = cData[indexPath.item]
        
        if let board = storyboard {
            let mpViewVC = board.instantiateController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            mpViewVC.currentIndex = indexPath.item
            mpViewVC.data = detailData
            mpViewVC.listData = cData
            mpViewVC.title = "Mp3 Player"
              self.presentAsModalWindow(mpViewVC)
          }
    }
    
    

}

extension ExploreViewController: NSCollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].detail.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cData = self.data[indexPath.section].detail
        let detailData = cData[indexPath.item]
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("ExploreCollectionViewItem"), for: indexPath) as! ExploreCollectionViewItem
        item.cellTextLabel.stringValue = detailData.story_name.trimmingCharacters(in: .whitespacesAndNewlines)
        item.cellImageView.image = NSImage.init(named: "image-placeholder")
        item.cellImageView.sd_setImage(with: URL.init(string: detailData.img_url)!, completed: nil)
        
        item.cellImageView.layer?.cornerRadius = 4
        item.cellImageView.layer?.masksToBounds = true
        
        
        return item
        
    }
    
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let headerview = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier.init("HeaderView"), for: indexPath) as! HeaderView
        let cData = self.data[indexPath.section]
        headerview.sectionLabel.stringValue = cData.title.trimmingCharacters(in: .whitespacesAndNewlines)
        headerview.numberLabel.stringValue = cData.subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
        headerview.wantsLayer = true
        headerview.layer?.backgroundColor = NSColor(hexString: "A0B3FB")?.cgColor
        return headerview
    }
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        if data != nil {
            return data.count
        }
        return 0
    }
    
    
 
    
}

extension ExploreViewController: NSCollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize.init(width: 1000, height: 40)
    }
    
}

// Play Mp3
extension ExploreViewController {
    
 
    
}
