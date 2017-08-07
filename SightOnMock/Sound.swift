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
    
    // データを保存。
    func save() {
        let realm = try! Realm()
        if realm.isInWriteTransaction {
            if self.soundId == 0 { self.soundId = self.createNewId() }
            realm.add(self, update: true)
        } else {
            try! realm.write {
                if self.soundId == 0 { self.soundId = self.createNewId() }
                realm.add(self, update: true)
            }
        }
    }
    
    // 新しいIDを採番します。
    private func createNewId() -> Int {
        let realm = try! Realm()
        return (realm.objects(type(of: self).self).sorted(byKeyPath: "soundId", ascending: false).first?.soundId ?? 0) + 1
    }
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "soundId"
    }
    
    // インデックスの設定
//    override static func indexedProperties() -> [String] {
//        return [""]
//    }
}
