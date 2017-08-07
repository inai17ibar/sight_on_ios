//
//  Sound.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/08/06.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import Foundation
import RealmSwift

// Tagクラス
class Tag: Object {
    dynamic var tagName: String = ""
}

class Sound: Object {
    dynamic var soundId: Int = 0
    dynamic var titleName: String = ""
    dynamic var userId: Int = 0
    dynamic var userName: String = ""
    let tags = List<Tag>()
    dynamic var created: Double = Date().timeIntervalSince1970
    dynamic var updated: Double = Date().timeIntervalSince1970
    dynamic var dataPath: String = ""
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "soundId"
    }
    
    // インデックスの設定
//    override static func indexedProperties() -> [String] {
//        return ["titleName"]
//    }
}
