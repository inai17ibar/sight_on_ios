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
    override func viewDidLoad() {
        super.viewDidLoad()

        //仮のDBの初期化ボタン
//        let accessor = DatabaseAccessManager()
//        
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
        let dataManager = TemporaryDataManager()
        let file_path = dataManager.loadDataPath()
        let url = URL(fileURLWithPath: file_path) //Postするとき，URL(fileURLWithPath: sound!.dataPath)
        print(url)
    }

    @IBAction func buttonTapped(_ sender : Any) {
        
        post()
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
