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



class ExploreViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var indicatorView: NSProgressIndicator!
    @IBOutlet weak var retryBtn: NSButton!
    
    var data :[TVListData]!
    var aid: String!
    var titleText: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    
        self.indicatorView.startAnimation(nil)
        self.getAudioList()
        self.retryBtn.isHidden = true

        
        self.tableView.doubleAction = #selector(tableViewDoubleClick)
    
    }
    
    
     @objc func tableViewDoubleClick() {
       
        // 1
        let item = self.data[self.tableView.selectedRow]
        print(item)
       
      if let board = storyboard {
                       let playerVC = board.instantiateController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
                       playerVC.title = "Music Player"
                       self.presentAsModalWindow(playerVC)
                   }
      }
      
  
    func getAudioList() -> Void {
        HttpApi.exploreList { (data, success) in
            if success {
                let jsonDecoder = JSONDecoder()
                let model = try! jsonDecoder.decode(TVMainData.self, from: data)
                self.data = model.data
                // decrypt
                self.tableView.reloadData()
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

extension ExploreViewController: NSTableViewDelegate {
    
    fileprivate enum Cellid {
        static let IconCell = "iconcellid"
        static let NameCell = "namecellid"
        static let SizeCell = "sizecellid"

    }
    
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
            // 点击 column 不是 item 的相应
      
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if data == nil {
            return nil
        }
        
        let tableData = self.data[row]
        
        if tableColumn == tableView.tableColumns[0] {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(Cellid.IconCell), owner: nil) as? IconTableCellView {
                let image = NSImage(byReferencing:NSURL(string: tableData.detail[0].img_url)! as URL)
                cell.image.image = image
                return cell
               }
        }
 
        
        return nil
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80
    }

}

extension ExploreViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if data != nil {
            return data.count
        }
        return 0
    }
    
}
