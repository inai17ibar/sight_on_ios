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

class FeedViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SoundPlayerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfield: UIView!
    var soundPlayer :SoundPlayer!
    let database = DatabaseAccessManager()
    var realm: Realm!
    var sounds:Results<Sound>!
    
    var limitedCellCount:Int! = 5
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,  self.textfield);
        //microphone access
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: {(granted: Bool) in})
        
        // 引っ張ってロードの初期化
        refreshControl = UIRefreshControl()
        //refreshControl.attributedTitle = NSAttributedString(string: "refresh")
        refreshControl.addTarget(self,
                                 action: #selector(FeedViewController.onRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //画面に来る度，毎回呼び出される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        realm = try! Realm()
        
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
        //sounds.count //読み込み済みデータ数を返すべき
        if section == 0
        {
            return limitedCellCount
            //return sounds.count
        }
        //通常はここに到達しない
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        print("currentOffsetY: \(currentOffsetY)")
        print("maximumOffset: \(maximumOffset)")
        print("distanceToBottom: \(distanceToBottom)")
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height {
            print("一番下に到達した時の処理")
        }
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
        let cell = tableView.cellForRow(at: indexPath) as! FeedListItemTableViewCell
        let voice_tag_url = URL(fileURLWithPath: sounds[indexPath.row].voice_tags[0].tagFilePath)

        print(seleted_url as Any)
        print(voice_tag_url as Any)
        
        if (soundPlayer.getSoundURL() == seleted_url)
        {
            //曲がセット済みのとき
            if soundPlayer.isPlaying(){
                cell.titleLabel.accessibilityLabel = cell.titleLabel.text
                ttsStopSound()
                soundPlayer.stop()
                
                // 選択を解除
                //tableView.deselectRow(at: indexPath, animated: true)
            }
            else{
                cell.titleLabel.accessibilityLabel = "再生中" //再生中の要素を示すため
                ttsPlaySound()
                //3秒の間ボイスタグを流して
                if(sounds[indexPath.row].voice_tags[0].tagFilePath != "")
                {
                    soundPlayer.play(url: voice_tag_url)
                    sleep(3)
                }
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
            cell.titleLabel.accessibilityLabel = "再生中"
            ttsPlaySound()
            //3秒の間ボイスタグを流して
            if(sounds[indexPath.row].voice_tags[0].tagFilePath != "")
            {
                soundPlayer.play(url: voice_tag_url)
                sleep(3)
            }
            soundPlayer.play(url: seleted_url)
        }
        // 選択を常に解除しておく(解除しないほうが状態がわかりそう)
        tableView.deselectRow(at: indexPath, animated: true)
        
        //OSのなどの仕様に依存するので非常に危険
        //sleep(UInt32(0.9)) //少し経ってから復活させる //1秒超えるとたいてい外れてしまう
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
    
    func onRefresh(_ refreshControl: UIRefreshControl){
        self.refreshControl.beginRefreshing()
        if(sounds.count >= limitedCellCount + 5)
        {
            limitedCellCount = sounds.count + 5
        }
        else
        {
            limitedCellCount = sounds.count
        }
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        tableView.reloadData()
    }
}
