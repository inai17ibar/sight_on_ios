//
//  AppDelegate.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let database = DatabaseAccessManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // ここに初期化処理を書く
        setDefaultDataset() //Realmの登録内容の初期化
        firstInstruction()
        return true
    }
    
    func firstInstruction()
    {
        let talker = AVSpeechSynthesizer()
        //let utterance = AVSpeechUtterance(string: "サイトオンのアプリでは．簡単な操作で音の録音と再生ができます。画面の上端の見出し部分をタッチすると，その画面のヘルプを読み上げます")
        let utterance = AVSpeechUtterance(string: "画面の上端をタッチするとヘルプを読み上げます。")

        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
    }
    
    func setDefaultDataset()
    {
        database.deleteAll()

        var audioPath = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")!
        database.create(audioPath, dataName: "17年08月08日 金沢", userId: 1, tags: ["お祭り", "夜"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "washroom", ofType:"wav")!
        database.create(audioPath, dataName: "17年06月09日 洗面所", userId: 1, tags: ["水", "癒やし"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "akihabara_lunch", ofType:"m4a")!
        database.create(audioPath, dataName: "17年06月11日 秋葉原", userId: 1, tags: ["ランチ"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "on_the_bridge", ofType:"m4a")!
        database.create(audioPath, dataName: "17年06月11日 橋の上", userId: 1, tags: ["風"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "ginza_east", ofType:"m4a")!
        database.create(audioPath, dataName: "2017年06月18日 東銀座", userId: 1, tags: ["話し声", "信号"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "on_stair", ofType:"m4a")!
        database.create(audioPath, dataName: "2017年06月20日 大崎", userId: 1, tags: ["階段"])
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

