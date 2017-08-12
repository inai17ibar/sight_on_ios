//
//  DatabaseAccessManager.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/08/12.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import RealmSwift

class DatabaseAccessManager{
    //singleton
    static let sharedInstance = DatabaseAccessManager()
    let sound: Sound!
    
    init (){
        sound = Sound()
    }
    
    func add()
    {
        if sound.id == 0 {
            return
        }
        let realm = try! Realm()
        
        // Realmへのオブジェクトの書き込み
        try! realm.write {
            realm.add(sound)
            print("add new data on database.")
        }
    }
    
    //TODO: 拡張に耐えられないので要リファクタリング
    func create(filePath: String, dataName: String, userId: Int, tags: [String])
    {
        // Tags型オブジェクトに変換してList<Tag>に格納
        let tagsList = List<Tag>()
        for tag in tags {
            let newTag = Tag()
            newTag.tagName = tag
            tagsList.append(newTag)
        }
        
        // Sound型オブジェクトの作成
        sound.sound_name = dataName
        sound.user_id = userId
        sound.tags.append(objectsIn: tagsList)
        sound.file_path = filePath
        sound.save()
    }
}
