//
//  FileApi.swift
//  RelaxMeMac
//
//  Created by jackrex on 3/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa

class FileApi: NSObject {
    
    public static func fileExist(url: String) -> Bool {
        var name = String(url.split(separator: "/").last!)
        if name.contains(".mp3") {
            
        }else {
            name = name + ".mp3"
        }
        let fileManger = FileManager.default
        let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let destinationPath : String = doumentDirectoryPath + "/" + "audio/" + name
        if !fileManger.fileExists(atPath: destinationPath) {
            return false
        }
        return true
    }
    
    public static func audioPath(url: String) -> String {
        var name = String(url.split(separator: "/").last!)
        if name.contains(".mp3") {
            
        }else {
            name = name + ".mp3"
        }
        return self.downloadPath() + name
    }
    
    public static func downloadPath() -> String {
        let fileManger = FileManager.default
        let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let destinationPath : String = doumentDirectoryPath + "/" + "audio/"
        if !fileManger.fileExists(atPath: destinationPath) {
            try? fileManger.createDirectory(atPath: destinationPath, withIntermediateDirectories: true, attributes: nil)
        }
        return destinationPath
    }
}
