//
//  RecordViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: ViewController{

    @IBOutlet weak var button: UIButton!

    var audioRecorder:AVAudioRecorder!
    var filePath:String!

    let dataManager = TemporaryDataManager()
    var soundPlayer:SoundPlayer!
    var currentControllerName = "Anonymous"

    private let feedbackGenerator: Any? = {
        if #available(iOS 10.0, *) {
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //初期化処理
        //soundPlayer = SoundPlayer() Willよりさきによばれるため
        //disactiveRecorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //音声の読み上げ
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "録音画面です。")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
        //初期化処理
        //soundPlayer = SoundPlayer()
        disactiveRecorder()
    }
    
    func disactiveRecorder()
    {
        filePath = NSHomeDirectory() + "/Documents/temp_data_"+getNowClockString()+".wav"
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
        filePath = NSHomeDirectory() + "/Documents/temp_data_"+getNowClockString()+".wav"
        let url = URL(fileURLWithPath: filePath)

        // 再生と録音の機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord) //AVAudioSessionCategoryPlayAndRecord) //AVAudioSessionCategoryRecord これにすると音をフィードバックを使えるかわりに音声にノイズが入る
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

    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let now = Date()
        return formatter.string(from: now)
    }

    //録音ボタンタップ
    @IBAction func buttonTapped(_ sender : Any) {

        //一時的にVOをオフ
        button.setTitle("録音中", for: .normal)
        button.accessibilityLabel = ""
        button.accessibilityHint = ""
        //読み上げ中でなければこれで読み上げが録音にはいらない
        
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            print("on haptic!")
        }
        
        //録音開始
        print("start recording")
        initRecorder()
        audioRecorder.record()

        sleep(5)
        
        //録音停止，データを一時保存
        audioRecorder.stop()
        saveRecordData()
        
        //音声の読み上げ
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "録音した音を読み込んでいます。まもなく，投稿画面に移動します。")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
        
        //次画面への遷移
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AutoEdit")
        self.present(nextViewController, animated:true, completion:nil)
    }

    func saveRecordData()
    {
        dataManager.saveDataPath(filePath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updatePlayBtnsTitle(text: String)
    {
        //messageLabel.text = text
    }
}
