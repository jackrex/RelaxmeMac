//
//  SecurityUtil.swift
//  RelaxMe
//
//  Created by jackrex on 2019/4/28.
//  Copyright © 2019 Sunny. All rights reserved.
//

import CryptoSwift

public class SecurityUtil: NSObject {

    static let shared = SecurityUtil()
    let key = "B31F2A75FBF94099"
    let iv = "B31F2A75FBF94099"
    
    private override init() {
        super.init()
    }
    
    func testSuccess() -> Void {
        let deco = SecurityUtil.shared.aesDecrypt("8hRs1VGakTAKD+NeGv0DqXoa/J4p44zthu/8SdCc2u3rkvMuhve/Jo8WzUU7OgS2kXWy2A0znqZQiwLdDMYkng==")
        let trimmedString = deco.replacingOccurrences(of: "\0", with: "")

        print(trimmedString)
    }
    
    func signature(_ path: String) -> String {
        var sig = ""
        let header = HttpApi.getHeader()
        let lang = header["x-lang"] as! String
        let version = header["x-version"] as! String
        
        let v = lang+path+version+HttpApi.random
        
        sig = v.sha1()
        print(sig)
        return sig
    }
    
    func mp3Url(_ url: String) -> String {
        return ""
    }
    
    func aesEncrypt(_ str: String) -> String {
        return str
    }
    
    //http://www.hangge.com/blog/cache/detail_1869.html
    func aesDecrypt(_ strToDecode: String) -> String {
        let data = NSData(base64Encoded: strToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data?.length
        
        // 把data 转成byte数组
        for i in 0..<count! {
            var temp:UInt8 = 0
            data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        
        // decode AES
        var decrypted: [UInt8] = []
        do {
            decrypted = try AES(key: key, iv: iv).decrypt(encrypted)
        } catch {
        }
        
        // byte 转换成NSData
        let encoded = Data(decrypted)
        var str = ""
        //解密结果从data转成string
        str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str
    }
    
}
