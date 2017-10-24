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
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        view.addGestureRecognizer(longGesture)
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
            
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
            showInstantAlert()
        }
    }
    func showInstantAlert() {
        
        // アラート作成
        let alert = UIAlertController(title: "録音画面に移ります", message: "", preferredStyle: .alert)
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("遷移の処理")
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        // アラート表示
        self.present(alert, animated: true, completion: nil)

    }
    
    //画面に来る度，毎回呼び出される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //画面状態の読み上げ
//        let talker = AVSpeechSynthesizer()
//        let utterance = AVSpeechUtterance(string: "再生リストです。")
//        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
//        talker.speak(utterance)
        
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
        let seleted_url = URL(fileURLWithPath: sounds[indexPath.row].file_path)
        
        //print((tableView.dequeueReusableCell(withIdentifier: "FeedListItem", for: indexPath) as! FeedListItemTableViewCell).titleLabel?.text as Any)
        let cell = tableView.cellForRow(at: indexPath) as! FeedListItemTableViewCell
        print(cell.titleLabel.text as Any)
        
        //Voセルのフォーカスを取れるか？の確認
        print(cell.accessibilityElementIsFocused())
        print(cell.titleLabel.accessibilityElementIsFocused())
        print(cell.titleLabel.isAccessibilityElement)
        cell.titleLabel.isAccessibilityElement = false
        print(cell.titleLabel.isAccessibilityElement)
        //cell.titleLabel.accessibilityLabel = "" //EnableをかえずLabelとHintだけ消してもタイトルがあるからつぎのときはVOされる
        //cell.titleLabel.accessibilityHint = ""
        
        if (soundPlayer.getSoundURL() == seleted_url)
        {
            //プレイヤーの曲がセット済みのとき
            if soundPlayer.isPlaying(){
                //print(cell.titleLabel.text as Any )
                //cell.titleLabel.isAccessibilityElement = true
                //cell.isAccessibilityElement = true
                //print(cell.titleLabel.isAccessibilityElement)
                //音声読み上げ
                let talker = AVSpeechSynthesizer()
                let utterance = AVSpeechUtterance(string: "再生停止")
                utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
                talker.speak(utterance)
                
                //cell.titleLabel.text = "" //せるがちゃんととれたらタイトルが消えて戻らない
                //print(cell.titleLabel.text as Any )
                //cell.titleLabel.accessibilityLabel = ""
                //cell.titleLabel.accessibilityHint = ""
                sleep(2)
                soundPlayer.stop()
            }
            else{
                
                //音声読み上げ
                let talker = AVSpeechSynthesizer()
                let utterance = AVSpeechUtterance(string: "再生")
                utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
                talker.speak(utterance)
                
                sleep(2)
                soundPlayer.play()
            }
        }
        else{
            //音声読み上げ
            let talker = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: "再生")
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker.speak(utterance)
            
            //cell.titleLabel.accessibilityLabel = ""
            //cell.titleLabel.accessibilityHint = ""
            sleep(2)
            //プレイヤーに曲がセット済みでないとき
            soundPlayer.play(url: seleted_url)
        }
        // 選択を解除しておく
        tableView.deselectRow(at: indexPath, animated: true)
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
