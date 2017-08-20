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

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, SoundPlayerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var soundPlayer :SoundPlayer!
    let database = DatabaseAccessManager()
    let realm = try! Realm()
    var sounds:Results<Sound>!
    var currentControllerName = "Anonymous"
    override func viewDidLoad() {
        super.viewDidLoad()

        //Realmの登録内容の初期化
        //if (database.extractByUserId(1).count > 6) {
            setDefaultDataset() //デプロイするたびにPathが変わるので．．．
        //}
        sounds = database.extractByUserId(1)

        soundPlayer = SoundPlayer()
        soundPlayer.delegate = self
        soundPlayer.initPlayer(url: URL(fileURLWithPath: sounds[0].file_path))
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListItem") as! FeedListItemTableViewCell
            
            cell.titleLabel.text = "\(sounds[indexPath.row].sound_name)"
            let tags_text = Array(sounds[indexPath.row].tags).reduce("") {
                (joined: String, x: Tag) -> String
                in return joined + " #" + x.tagName
            }
            cell.tagLabel.text = "\(tags_text)"
            
            //サンプル画像
            let image:UIImage = UIImage(named:"sample")!
            cell.photo = UIImageView(image:image)
            
            return cell
        }
        return UITableViewCell()
    }
    
    //あるセルを押したら再生
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        //soundPlayer.initPlayer(url: URL(fileURLWithPath: sounds[indexPath.row].file_path))
        let seleted_url = URL(fileURLWithPath: sounds[indexPath.row].file_path)
        print(sounds[indexPath.row].file_path)
        print(seleted_url)
        if (soundPlayer.getSoundURL() == seleted_url){
            //プレイヤーの曲がセット済みのとき
            if soundPlayer.isPlaying(){
                soundPlayer.stop()
            }else{
                soundPlayer.play()
            }
        }
        else{
            //プレイヤーに曲がセット済みでないとき
            soundPlayer.play(url: seleted_url)
        }
        
        // 選択を解除しておく
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //あるセルをスワイプしたら
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //closure
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            try! self.realm.write{
                self.realm.delete(self.sounds[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    func updateMessage(text: String)
    {
        
    }
    
    func updatePlayBtnsTitle(text: String)
    {
        
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
