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
    @IBOutlet weak var textfield: UIView!
    var soundPlayer :SoundPlayer!
    let database = DatabaseAccessManager()
    let realm = try! Realm()
    var sounds:Results<Sound>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,  self.textfield);
        //microphone access
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: {(granted: Bool) in})
    }
    
    //画面に来る度，毎回呼び出される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //データの読み出し，更新
        sounds = database.extractByUserId(1)
        soundPlayer = SoundPlayer()
        soundPlayer.delegate = self
        soundPlayer.initPlayer(url: URL(fileURLWithPath: sounds[0].file_path))
        
        //Now reload the tableView
        self.tableView.reloadData()
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.navigationController?.navigationBar.topItem)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        soundPlayer.stop()
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
            //print(cell.titleLabel.text as Any )
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
        //print(indexPath.row)
        //print(sounds.count)
        //let reverse_index = (sounds.count - 1) - indexPath.row
        let seleted_url = URL(fileURLWithPath: sounds[indexPath.row].file_path)
        let cell = tableView.cellForRow(at: indexPath) as! FeedListItemTableViewCell

        print(seleted_url as Any)
        
        //cell.isAccessibilityElement = false
        //cell.titleLabel.isAccessibilityElement = false
        
        //cell.titleLabel.accessibilityHint = ""
        //print(soundPlayer.getSoundURL() as Any)
        
        if (soundPlayer.getSoundURL() == seleted_url)
        {
            //曲がセット済みのとき
            if soundPlayer.isPlaying(){
                cell.titleLabel.accessibilityLabel = cell.titleLabel.text
                ttsStopSound()
                soundPlayer.stop()
                
                // 選択を解除
                tableView.deselectRow(at: indexPath, animated: true)
            }
            else{
                cell.titleLabel.accessibilityLabel = ""
                ttsPlaySound()
                soundPlayer.play(url: seleted_url)
            }
        }
        else{
            let cells = tableView.visibleCells as! [FeedListItemTableViewCell]
            for cell_i in cells
            {
                cell_i.titleLabel.accessibilityLabel = cell_i.titleLabel.text
            }
            //曲がセットされてないとき
            cell.titleLabel.accessibilityLabel = ""
            ttsPlaySound()
            soundPlayer.play(url: seleted_url)
        }
        // 選択を解除しておく(解除しないほうが状態がわかりそう)
        //tableView.deselectRow(at: indexPath, animated: true)
        //cell.titleLabel.isAccessibilityElement = true
        
        //OSのなどの仕様に依存するので非常に危険
        //sleep(UInt32(0)) //少し経ってから復活させる //1秒超えるとたいてい外れてしまう
        //cell.titleLabel.accessibilityLabel = "選択中" //cell.titleLabel.text
    }
    
    private func ttsPlaySound()
    {
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "再生")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
        
        sleep(2)
    }
    
    private func ttsStopSound()
    {
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "再生停止")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
        
        sleep(2)
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
    
}
