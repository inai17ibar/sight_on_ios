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
    
    let database = DatabaseAccessManager()
    let realm = try! Realm()
    var sounds:Results<Sound>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //既存データでの読み込みテスト
        //let audioPath = Bundle.main.path(forResource: "/Documents/temp_data", ofType:"m4a")!
        //let audioUrl = URL(fileURLWithPath: audioPath)
        //print("\(audioPath)")
        
        if database.extractByUserId(number: 1).count > 5 {
            setDefaultDataset()
        }
        sounds = database.extractByUserId(number: 1)
        
        //var soundUrls = sounds.filter( {(x: Sound) -> URL in return URL(fileURLWithPath: x.file_path)})
    
        initAudioPlayer(url: URL(fileURLWithPath: sounds[0].file_path))
    }
    
    func initAudioPlayer(url :URL)
    {
        // audio を再生するプレイヤーを作成する
        do{
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
        }
        catch{
            print("Error: cannot init audioPlayer")
        }
    }
    
    func setDefaultDataset()
    {
        database.deleteAll()
        
        let audioPath1 = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")!
        database.create(filePath: audioPath1, dataName: "有楽町", userId: 1, tags: ["night", "cool", "refresh"])
        database.add()
        
        let audioPath2 = Bundle.main.path(forResource: "near_road", ofType:"wav")!
        database.create(filePath: audioPath2, dataName: "道路", userId: 1, tags: ["road", "buzy"])
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
//            
            //サンプル
            let image:UIImage = UIImage(named:"sample")!
            cell.photo = UIImageView(image:image)
            
            return cell
        }
        return UITableViewCell()
    }
    
    //あるセルを押したら再生
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        initAudioPlayer(url: URL(fileURLWithPath: sounds[indexPath.row].file_path))
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        else{
            audioPlayer.play()
        }
    }
    
    //あるセルをスワイプしたら
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //closure
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            //self.array.remove(at: indexPath.row)
            try! self.realm.write{
                self.realm.delete(self.sounds[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    // 音楽再生が成功した時に呼ばれるメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        
    }
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {
        print("Error")
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
