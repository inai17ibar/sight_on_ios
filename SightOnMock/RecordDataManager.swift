//
//  RecordDataManager.swift
//  
//
//  Created by inatani soichiro on 2017/08/11.
//
//

import UIKit

//TempData
class RecordDataManager {
    //singleton
    static let sharedInstance = RecordDataManager()
    private var filePath: String
    let userDefaults = UserDefaults.standard
    
    init()
    {
        filePath = ""
    }
    
    public func saveData()
    {
        userDefaults.register(defaults: ["DataStore": "default"])
        
        let userDefault = UserDefaults.standard
        // キーを指定してオブジェクトを保存
        userDefault.set("TEST", forKey: "Key")
    }
    
    public func readData()
    {
        userDefaults.string(forKey: "Key")
        
        return
    }
    // Keyを指定して読み込み(使用イメージ)
    //let str: String = userDefaults.object(forKey: "DataStore") as! String
    
    public func deleteData()
    {
        userDefaults.removeObject(forKey: "Key")
    }
}
