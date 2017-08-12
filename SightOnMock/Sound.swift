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
    dynamic var id: Int = 0
    dynamic var sound_name: String = ""
    dynamic var file_path: String = ""
    dynamic var user_id: Int = 0
    
    let tags = List<Tag>()
    
    dynamic var created_stamp: Double = Date().timeIntervalSince1970
    dynamic var updated_stamp: Double = Date().timeIntervalSince1970
    
    // データを保存。
    func save() {
        let realm = try! Realm()
        if realm.isInWriteTransaction {
            if self.id == 0 { self.id = self.createNewId() }
            realm.add(self, update: true)
        } else {
            try! realm.write {
                if self.id == 0 { self.id = self.createNewId() }
                realm.add(self, update: true)
            }
        }
    }
    
    // 新しいIDを採番します。
    private func createNewId() -> Int {
        let realm = try! Realm()
        return (realm.objects(type(of: self).self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
    }
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // インデックスの設定
//    override static func indexedProperties() -> [String] {
//        return [""]
//    }
}
