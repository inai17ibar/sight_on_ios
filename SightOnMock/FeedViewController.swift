//
//  FeedViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var audioPlayer:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 新規オブジェクトをインサート
        if false //同じキーが繰り返し入ってしまうので一回Realmに入れたらFalseにする
        {
            let audioPath = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")!
            createSoundData(soundId: 1, titleName: "test1", userId: 1, userName: "wakeke",
                            tags: ["night", "cool", "refresh"], created: Date().timeIntervalSince1970, updated: Date().timeIntervalSince1970, dataPath: audioPath)
        }
        
        let realm = try! Realm()
        let sound = realm.objects(Sound.self).filter("soundId == 1").first //%@, val 非Optional型はnilが入らない
        let audioUrl = URL(fileURLWithPath: sound!.dataPath)
        print("\(sound!.dataPath)")
        
        // auido を再生するプレイヤーを作成する
        do{
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
        }
        catch{
        }
        
        //audioPlayer.prepareToPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListItem") as! FeedListItemTableViewCell
            
            cell.title_name.text = "\(indexPath.row)"
            let image:UIImage = UIImage(named:"sample")!
            cell.photo = UIImageView(image:image)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ( audioPlayer.isPlaying ){
            audioPlayer.stop()
            //button.setTitle("Stop", for: UIControlState())
        }
        else{
            audioPlayer.play()
            //button.setTitle("Play", for: UIControlState())
        }
    }
    
    // 音楽再生が成功した時に呼ばれるメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {}
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {}
    
    
    func createSoundData(soundId: Int, titleName: String, userId: Int, userName: String, tags: [String], created: Double, updated: Double, dataPath: String) {
        
        // Tags型オブジェクトに変換してList<Tag>に格納
        let tagsList = List<Tag>()
        for tag in tags {
            let newTag = Tag()
            newTag.tagName = tag
            tagsList.append(newTag)
        }
        
        let realm = try! Realm()
        
        // Sound型オブジェクトの作成
        let sound = Sound()
        sound.soundId = soundId
        sound.titleName = titleName
        sound.userId = userId //realm.objects(Sound.self).count
        sound.userName = userName
        sound.tags.append(objectsIn: tagsList)
        sound.created = created
        sound.updated = updated
        sound.dataPath = dataPath
        
        // Realmへのオブジェクトの書き込み
        try! realm.write {
            realm.add(sound)
        }
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
