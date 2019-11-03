//
//  HttpApi.swift
//  RelaxMeMac
//
//  Created by jackrex on 2/11/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Cocoa
import Alamofire

class HttpApi: NSObject {

       #if DEBUG
    //    static let host = "https://stg-api.relaxme.top"
        static let host = "https://calmzen.leanapp.cn"

        #else
        static let host = "https://api.relaxme.top"
        #endif
        
         static func getHeader() -> HTTPHeaders {
               let headers: HTTPHeaders = [
                   "Accept": "application/json",
                   "Content-Type": "application/json",
                   "x-lang": languageHeader(),
                   "x-version": shortVersion()
               ]
               return headers
           }
           
           static let random = "dJwzKvBNgQuc3MyFhihyCtZB"

           
           static func languageHeader() -> String {
               var allLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as? [Any]
               let preferredLanguage = allLanguages?[0] as? String
               return preferredLanguage!
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
           
           public static func appName() -> String {
               return "CFBundleDisplayName".localized()
               
           }
           
           static func signParams(_ path: String) ->[String: String] {
               let dic = ["sig": SecurityUtil.shared.signature(path)]
               return dic
           }
           
           
           static let netmanager: SessionManager = {
               let configuration = URLSessionConfiguration.default
               let reachability = NetworkReachabilityManager()
               if (reachability?.isReachable)! {
                   configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
               }else
               {
                   configuration.requestCachePolicy = .returnCacheDataElseLoad
               }
               return Alamofire.SessionManager(configuration: configuration)
           }()
           
           public static func exploreList(_ completion: @escaping (Data, Bool) -> ()) -> Void {
               
               netmanager.request(host + "/explore/tv", method: .get, parameters: signParams("/explore/tv"), encoding: JSONEncoding.default, headers: getHeader()).validate(statusCode: 200..<300).responseData { (response) in
                   switch response.result {
                   case .success:
                       print(String.init(data: response.result.value!, encoding: String.Encoding.utf8)!)
                       completion(response.result.value!, true)
                       break
                   case .failure(let error):
                       completion(Data.init(), false)
                       print(error)
                       break
                       
                   }
               }
           }
      
    
    
}
