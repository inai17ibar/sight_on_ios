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

        soundPlayer = SoundPlayer()
        disactiveRecorder()
    }
    override func viewWillAppear(_ animated: Bool) {
    let talker = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: "録音画面です。")
    utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
    talker.speak(utterance)
    }
    func disactiveRecorder()
    {
        // 録音ファイルを指定する
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

        // 再生と録音の機能をアクティブにする
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

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSetting)
        } catch {
            fatalError("cannot init AudioRecorder")
        }
    }

    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMdd"
        let now = Date()
        return formatter.string(from: now)
    }

    @IBAction func buttonTapped(_ sender : Any) {

        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            //print("on haptic!")
        }

        print("start recording")
        initRecorder()
        let instruction_text = ""
        button.setTitle(instruction_text, for: .normal)
        audioRecorder.record()

        sleep(5) //仮説：Feedbackがないから重く感じる？

        audioRecorder.stop()
        saveRecordData()

        disactiveRecorder()

        //soundPlayer.initPlayer(url: URL(fileURLWithPath: dataManager.loadDataPath()))
        let talker = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: "アプリが音を編集しています。間も無く投稿画面に移動します。")
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
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
