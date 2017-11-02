//
//  VoiceTagViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/10/28.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

class VoiceTagViewController: ViewController {
    
    @IBOutlet weak var recordButton: UIButton!

    var audioRecorder:AVAudioRecorder!
    var filePath:String!
    let temp_data = TemporaryDataManager()
    let database = DatabaseAccessManager()
    
    //let dataManager = TemporaryDataManager()
    var soundPlayer:SoundPlayer!
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordButton.setTitle("音声タグの録音開始", for: .normal)
        disactiveRecorder()
    }
    
    func disactiveRecorder()
    {
        filePath = NSHomeDirectory() + "/Documents/voice_tag_"+getNowClockString()+".wav"
        let url = URL(fileURLWithPath: filePath)
        
        // 録音の詳細設定
        let recordSetting : [String : AnyObject] = [
            AVFormatIDKey : UInt(kAudioFormatALaw) as AnyObject,
            AVEncoderAudioQualityKey : AVAudioQuality.min.rawValue as AnyObject,
            AVEncoderBitRateKey : 16 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey: 44100.0 as AnyObject
        ]
        
        // 録音の機能をオフにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategorySoloAmbient)
        try! session.setActive(true)
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSetting)
        } catch {
            fatalError("cannot init AudioRecorder")
        }
    }
    
    func initRecorder()
    {
        // 録音ファイルを指定する
        filePath = NSHomeDirectory() + "/Documents/voice_tag_"+getNowClockString()+".wav"
        let url = URL(fileURLWithPath: filePath)
        
        // 再生と録音の機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord) //AVAudioSessionCategoryRecord これにすると音をフィードバックを使えるかわりに音声にノイズが入る
        try! session.setActive(true)
        
        // 録音の詳細設定
        let recordSetting : [String : AnyObject] = [
            AVFormatIDKey : UInt(kAudioFormatALaw) as AnyObject,
            AVEncoderAudioQualityKey : AVAudioQuality.min.rawValue as AnyObject,
            AVEncoderBitRateKey : 16 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey: 44100.0 as AnyObject
        ]
        
        print("success init AudioRecorder")
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSetting)
        } catch {
            fatalError("cannot init AudioRecorder")
        }
    }
    
    //録音ボタンタップ
    @IBAction func buttonTapped(_ sender : Any) {
        //一時的にVOをオフ
        recordButton.setTitle("録音中", for: .normal)
        recordButton.backgroundColor = UIColor(red: 255/255, green: 126/255, blue: 121/255, alpha: 1.0)
        recordButton.accessibilityLabel = ""
        recordButton.accessibilityHint = ""
        //読み上げ中でなければこれで読み上げが録音にはいらない
        
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            print("on haptic!")
        }
        
        isRecording=true;
        //録音開始
        print("start recording")
        initRecorder()
        showAlert()
    }

    func showAlert() {
        // アラートを作成
        let alert = UIAlertController(
            title: "",
            message: "録音中",
            preferredStyle: .alert)//.actionSheet
        // アクションシートの親となる UIView を設定
        alert.popoverPresentationController?.sourceView = self.view
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "録音終了", style: .default, handler: { action in
            self.finishRecord()
        }))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
        sleep(2)
        self.audioRecorder.record()
    }
    
    func finishRecord(){
        // 押されたら実行したい処理
        print("finish recording")
        self.recordButton.setTitle("録音終了", for: .normal)
        self.recordButton.backgroundColor = UIColor(red: 198/255, green: 200/255, blue: 201/255, alpha: 1.0)
        //録音停止，音声タグデータを保存
        self.audioRecorder.stop()
        //self.saveRecordData()
        disactiveRecorder()
        self.post()
        
        //次画面への遷移
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func post()
    {
        let sound_file_path = temp_data.loadDataPath()
        print()
        database.create(sound_file_path, dataName: getNowClockString(), userId: 1, tags:[""], voiceTags: [filePath]) 
        database.add()
        temp_data.deleteData()
    }
    
    func saveRecordData()
    {
        //dataManager.saveDataPath(filePath)
    }
}
