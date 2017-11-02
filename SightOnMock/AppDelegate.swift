//
//  AppDelegate.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let database = DatabaseAccessManager()

    // Override point for customization after application launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Realmのマイグレーション
        let config = Realm.Configuration(
            // 新しいスキーマバージョンを設定します。 これは以前に使用されたものよりも大きくなければなりません
            // version（以前にスキーマバージョンを設定していない場合、バージョンは0です）。
            schemaVersion: 1,
            
            //スキーマのバージョンが上記のものよりも低い/を開くときに自動的に呼び出されるブロックを設定する
            migrationBlock: { migration, oldSchemaVersion in
                //まだ何も移行していないので、oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Realmは新しいプロパティと削除されたプロパティを自動的に検出します
                    //そして自動的にディスク上のスキーマを更新する
                }})
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        //デフォルトのレルムに対してこの新しい設定オブジェクトを使用するようにRealmに指示します
        let realm = try! Realm()
        print(realm, "Realm")
        print(config,"Realm Version")
        
        // ここに初期化処理を書く
        setDefaultDataset() //Realmの登録内容の初期化
        //firstInstruction()
        return true
    }
    
    func firstInstruction()
    {
        //let talker = AVSpeechSynthesizer()
        //let utterance = AVSpeechUtterance(string: "サイトオンのアプリでは．簡単な操作で音の録音と再生ができます。画面の上端の見出し部分をタッチすると，その画面のヘルプを読み上げます")
        //let utterance = AVSpeechUtterance(string: "画面の上の見出しをタッチすると、ヘルプを読み上げます。")
        //utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        //talker.speak(utterance)
    }
    
    func setDefaultDataset()
    {
        database.deleteAll()
        
        //古い順にいれる
        var audioPath = Bundle.main.path(forResource: "washroom", ofType:"wav")!
        database.create(audioPath, dataName: "06月09日", userId: 1, tags: ["水", "癒やし"], voiceTags: [""])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "akihabara_lunch", ofType:"m4a")!
        database.create(audioPath, dataName: "06月11日 秋葉原", userId: 1, tags: ["ランチ"], voiceTags: [""])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "on_the_bridge", ofType:"m4a")!
        database.create(audioPath, dataName: "06月11日 勝どき", userId: 1, tags: ["風"], voiceTags: [""])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "ginza_east", ofType:"m4a")!
        database.create(audioPath, dataName: "06月18日 東銀座", userId: 1, tags: ["話し声", "信号"], voiceTags: [""])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "on_stair", ofType:"m4a")!
        database.create(audioPath, dataName: "06月20日 大崎", userId: 1, tags: ["階段"], voiceTags: [""])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")!
        database.create(audioPath, dataName: "08月08日 有楽町", userId: 1, tags: ["お祭り", "夜"], voiceTags: [""])
        database.add()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

