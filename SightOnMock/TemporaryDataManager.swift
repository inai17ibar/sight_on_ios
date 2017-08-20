//
//  RecordDataManager.swift
//  
//
//  Created by inatani soichiro on 2017/08/11.
//
//

import UIKit

class TemporaryDataManager {
    //singleton
    static let sharedInstance = TemporaryDataManager()
    fileprivate var filePath: String
    let userDefaults = UserDefaults.standard
    
    init()
    {
        userDefaults.register(defaults: ["DataStore": "default"])
        filePath = ""
    }
    
    open func saveDataPath(_ path :String)
    {
        let userDefault = UserDefaults.standard
        // キーを指定してオブジェクトを保存
        userDefault.set(path, forKey: "Key")
    }
    
    open func loadDataPath() -> String
    {
        return userDefaults.string(forKey: "Key")!
    }
    
    /*open func saveEditDataPath(_ path :String)
    {
        let userDefault = UserDefaults.standard
        // キーを指定してオブジェクトを保存
        userDefault.set(path, forKey: "Key")
    }
    
    open func loadEditDataPath() -> String
    {
        return userDefaults.string(forKey: "Key")!
    }*/
    // Keyを指定して読み込み(使用イメージ)
    //let filePath: String = loadDataPath()
    
    open func deleteData()
    {
        userDefaults.removeObject(forKey: "Key")
        //TODOpathのファイルを削除する処理
        print("Delete temporary data.")
    }
}
