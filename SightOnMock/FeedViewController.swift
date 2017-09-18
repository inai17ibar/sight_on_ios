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

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, SoundPlayerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var soundPlayer :SoundPlayer!
    let database = DatabaseAccessManager()
    let realm = try! Realm()
    var sounds:Results<Sound>!
    var currentControllerName = "Anonymous"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //画面に来る度，毎回呼び出される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //画面状態の読み上げ
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "フィード画面です。")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
        
        //データの読み出し，更新
        sounds = database.extractByUserId(1)
        soundPlayer = SoundPlayer()
        soundPlayer.delegate = self
        soundPlayer.initPlayer(url: URL(fileURLWithPath: sounds[0].file_path))
        
        //Now reload the tableView
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    //セルのデータの読み出し
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListItem") as! FeedListItemTableViewCell
            
            cell.titleLabel.text = "\(sounds[indexPath.row].sound_name)"
//            let tags_text = Array(sounds[indexPath.row].tags).reduce("タグ： ") {
//                (joined: String, x: Tag) -> String
//                in return joined + x.tagName + ", "
//            }
//            cell.tagLabel.text = "\(tags_text)"
            
            return cell
        }
        return UITableViewCell()
    }
    
    //あるセルを押したら再生
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        let seleted_url = URL(fileURLWithPath: sounds[indexPath.row].file_path)
        if (soundPlayer.getSoundURL() == seleted_url){
            //プレイヤーの曲がセット済みのとき
            if soundPlayer.isPlaying(){
                //音声読み上げ
                let talker = AVSpeechSynthesizer()
                let utterance = AVSpeechUtterance(string: "再生停止")
                utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
                talker.speak(utterance)
                
                soundPlayer.stop()
                // 選択を解除しておく
                tableView.deselectRow(at: indexPath, animated: true)
            }
            else{
                //音声読み上げ
                let talker = AVSpeechSynthesizer()
                let utterance = AVSpeechUtterance(string: "再生")
                utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
                talker.speak(utterance)
                
                soundPlayer.play()
            }
        }
        else{
            //音声読み上げ
            let talker = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: "再生")
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker.speak(utterance)
            
            //プレイヤーに曲がセット済みでないとき
            soundPlayer.play(url: seleted_url)
        }
    }
        
    func updateMessage(text: String)
    {
        
    }
    
    func updatePlayBtnsTitle(text: String)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
