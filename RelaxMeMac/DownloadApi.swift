//
//  DownloadApi.swift
//  RelaxMeMac
//
//  Created by jackrex on 3/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa
import Alamofire

class DownloadApi: NSObject {
    
    public static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
          URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
      }
      
      @discardableResult
      public static func downloadFile(url: String,  complete: @escaping (_ success: Bool)->()) -> Any{
          
          if FileApi.fileExist(url: url) {
              complete(true)
              return -1
          }
          
          var name = String(url.split(separator: "/").last!)
          if name.contains(".mp3") {
              
          }else {
              name = name + ".mp3"
          }
          let destination: DownloadRequest.DownloadFileDestination = { _, _ in
              let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
              let fileURL = documentsURL.appendingPathComponent("audio").appendingPathComponent(name)
              return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
          }
          
          
          let request = Alamofire.download(url, to: destination).response { response in
              if response.error == nil, let _ = response.destinationURL?.path {
                  complete(true)
              }else {
                  print("error")
                  complete(false)
              }
          }
          
          return request
          
      }

}
