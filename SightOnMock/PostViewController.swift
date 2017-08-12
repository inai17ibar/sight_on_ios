//
//  PostViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit

class PostViewController: ViewController {

    @IBOutlet weak var postButton: UIButton!
    
    let dataManager = TemporaryDataManager()
    let accessor = DatabaseAccessManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setDefaultDataset()
    {
        //仮のDBの初期化ボタン
        //        let accessor = DatabaseAccessManager()
        //全レコードを消す
        //        let audioPath1 = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")!
        //        accessor.createSoundData(filePath: audioPath1, dataName: "有楽町", userId: 1, tags: ["night", "cool", "refresh"])
        //        let audioPath2 = Bundle.main.path(forResource: "near_road", ofType:"wav")!
        //        accessor.createSoundData(filePath: audioPath2, dataName: "道路", userId: 1, tags: ["road", "buzy"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func post()
    {
        let file_path = dataManager.loadDataPath()
        //let url = URL(fileURLWithPath: file_path)
        print("post")
        accessor.create(filePath: file_path, dataName: "test1", userId: 1, tags:["fun", "happy", "hot"])
        accessor.add()
    }

    @IBAction func buttonTapped(_ sender : Any)
    {
        post()
        postButton.setTitle("finish posted", for: .normal)
        //矯正遷移をつける？
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
