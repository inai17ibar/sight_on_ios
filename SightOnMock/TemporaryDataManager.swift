//
//  RecordDataManager.swift
//  
//
//  Created by inatani soichiro on 2017/08/11.
//
//

import UIKit

//TempData
class TemporaryDataManager {
    //singleton
    static let sharedInstance = TemporaryDataManager()
    private var filePath: String
    let userDefaults = UserDefaults.standard
    
    init()
    {
        userDefaults.register(defaults: ["DataStore": "default"])
        filePath = ""
    }
    
    public func saveData(path :String)
    {
        let userDefault = UserDefaults.standard
        // キーを指定してオブジェクトを保存
        userDefault.set(path, forKey: "Key")
    }
    
    public func loadData() -> String
    {
        return userDefaults.string(forKey: "Key")!
    }
    // Keyを指定して読み込み(使用イメージ)
    //let str: String = loadData()
    
    public func deleteData(path :String)
    {
        userDefaults.removeObject(forKey: "Key")
        //TODOpathのファイルを削除する処理
        print("Delete temporary data.")
    }
}
