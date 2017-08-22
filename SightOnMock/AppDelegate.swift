//
//  AppDelegate.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let database = DatabaseAccessManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // ここに初期化処理を書く
        setDefaultDataset() //Realmの登録内容の初期化
        return true
    }
    
    func setDefaultDataset()
    {
        database.deleteAll()

        var audioPath = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")!
        database.create(audioPath, dataName: "有楽町", userId: 1, tags: ["night", "cool", "refresh"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "washroom", ofType:"wav")!
        database.create(audioPath, dataName: "洗面所", userId: 1, tags: ["water", "healing"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "akihabara_lunch", ofType:"m4a")!
        database.create(audioPath, dataName: "秋葉原", userId: 1, tags: ["lunch"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "on_the_bridge", ofType:"m4a")!
        database.create(audioPath, dataName: "橋の上", userId: 1, tags: ["wind"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "ginza_east", ofType:"m4a")!
        database.create(audioPath, dataName: "東銀座", userId: 1, tags: ["talking"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "on_stair", ofType:"m4a")!
        database.create(audioPath, dataName: "階段", userId: 1, tags: ["tonton"])
        database.add()
        
        audioPath = Bundle.main.path(forResource: "India", ofType:"wav")!
        database.create(audioPath, dataName: "インドの街", userId: 1, tags: ["night", "India", "dangerous"])
        database.add()
        audioPath = Bundle.main.path(forResource: "India", ofType:"wav")!
        database.create(audioPath, dataName: "エレベーター", userId: 1, tags: ["elevator"])
        database.add()
        audioPath = Bundle.main.path(forResource: "India", ofType:"wav")!
        database.create(audioPath, dataName: "ケチャダンス", userId: 1, tags: ["kecak", "dance"])
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

