//
//  Model.swift
//  RelaxMeTV
//
//  Created by jackrex on 12/5/2019.
//  Copyright © 2019 Sunny. All rights reserved.
//

import Foundation

struct TVMainData: Codable {
      let data:[TVListData]
}

struct TVListData: Codable {
    let id: String
    let title: String
    let subtitle: String
    let detail:[TVListDetail]
}

struct TVListDetail:Codable {
    var story_id: Int
    var story_name: String
    var size: String
    var length: String
    var img_url: String
    var music_url: String
}
