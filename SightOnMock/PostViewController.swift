//
//  PostViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import AudioUnit
import AudioToolbox

class PostViewController: ViewController {
    @IBOutlet weak var Editbutton: UIButton!
    let buttonLabel: [String] = ["オリジナル", "リバーブ1", "リバーブ2", "リバーブ3"]
    var buttonidx=0
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var textfield: UINavigationBar!
    let temp_data = TemporaryDataManager()
    let database = DatabaseAccessManager()
    
    private let feedbackGenerator: Any? = {
        if #available(iOS 10.0, *) {
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            return generator
        } else {
            return nil
        }
    }()
    
    // インスタンス変数
    var engine = AVAudioEngine()
    //playerNodeの準備
    var player = AVAudioPlayerNode()
    //revebNodeの準備
    var reverb = AVAudioUnitReverb()
    //AVAudioUnitDelayの準備
    var delay = AVAudioUnitDelay()
    //その他の変数の準備
    var audiolength = 0
    var audioFormat = AVAudioFormat()
    //読み込みfile関係
    let file_path = TemporaryDataManager().loadDataPath()
    let fileUrl = URL(fileURLWithPath: TemporaryDataManager().loadDataPath())
    var isEffected=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,  self.textfield);
        //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        //プレイヤーの初期化
        do {
            let audioFile = try AVAudioFile(forReading: fileUrl)
            self.audioFormat = audioFile.processingFormat
            
            // reverbの設定
            reverb.loadFactoryPreset(.largeHall2)
            reverb.wetDryMix = 0
            
            //Delayの設定
            // 高域側のカットオフ周波数
            //audioFile.processingFormat.sampleRate
            delay.lowPassCutoff = 15000;    // Range: 10 -> (samplerate/2)
            delay.delayTime = 0;
            delay.feedback = 0;
            // AudioEngineにnodeを設定
            player.reset()
            engine.reset()
            engine.attach(player)
            engine.attach(reverb)
            engine.attach(delay)
            engine.connect(player, to: delay, format: audioFile.processingFormat)
            engine.connect(delay, to: reverb, format: audioFile.processingFormat)
            engine.connect(reverb, to: engine.outputNode, format: audioFile.processingFormat)
        } catch let error {
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //再生の準備
        do {
            //print(fileUrl)
            let audioFile = try AVAudioFile(forReading: fileUrl)
            self.audioFormat = audioFile.processingFormat
            let audioFormat = audioFile.processingFormat
            let audioFrameCount = UInt32(audioFile.length)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            audiolength = Int(audioFrameCount)
            try! audioFile.read(into: audioFileBuffer)
            engine.prepare()
            do{
                try! engine.start()
            }
            // playerにオーディオファイルを設定
            self.player.scheduleBuffer(audioFileBuffer, at: nil, options:.loops, completionHandler: { () -> Void in
            })
            // 再生開始
            self.player.play()
        } catch let error {
            print(error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        let now = Date()
        return formatter.string(from: now)
    }
    
    func post()
    {
        if(isEffected){
        saveData()
        }
        let file_path = temp_data.loadDataPath()
        database.create(file_path, dataName: getNowClockString(), userId: 1, tags:[""])
        database.add()
        temp_data.deleteData()
    }

    func saveData()
    {
        let save_file_path = file_path
        let fileUrl_write = URL(fileURLWithPath: save_file_path)
        var goFlag=false
        
        do{
            let audioFile_write = try AVAudioFile(forWriting: fileUrl_write, settings: audioFormat.settings)
            reverb.installTap(onBus: 0, bufferSize: AVAudioFrameCount(audiolength), format: audioFormat, block: {buffer, when in
                if Int(audioFile_write.length) < self.audiolength{//Let us know when to stop saving the file, otherwise saving infinitely
                    do{
                        try audioFile_write.write(from: buffer)
                        //print(audioFile_write.length)
                    }catch let error{
                        print("Buffer error", error)
                    }
                }else{
                    self.reverb.removeTap(onBus: 0)//if we dont remove it, will keep on tapping infinitely
                    //audioFile_write=nil
                    self.player.stop()
                    self.engine.stop()
                    goFlag = true;
                }
                
            })
        }catch let error {
            print("AVAudioFile error:", error)
        }
        
        //処理待ちをしている？
        while(!goFlag){
            usleep(200000)
        }
    }
    
    //投稿ボタンをおしたとき
    @IBAction func buttonTapped(_ sender : Any)
    {
        postButton.accessibilityLabel = ""
        postButton.accessibilityHint = ""
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            print("on haptic!")
        }
        
        //投稿処理
        post()
        
        //再生停止
        self.player.stop()
        self.showPostAlert()
    }
    
    @IBAction func dismissButtonTapped(_ sender : Any)
    {
        dismissButton.accessibilityLabel = ""
        dismissButton.accessibilityHint = ""
        
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            //print("on haptic!")
        }
        
        //一時データ削除
        temp_data.deleteData()

        //再生停止
        self.player.stop()
        self.showDismissAlert()

    }
    
    @IBAction func editbuttonTapped(_ sender : Any)
    {
        buttonidx += 1;
        if buttonidx>=buttonLabel.count{
            buttonidx=0;
        }
        Editbutton.setTitle(buttonLabel[buttonidx], for: .normal)
        switch buttonidx {
        case 0:
            //音声読み上げ
            let talker = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: "オリジナル")
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker.speak(utterance)
            reverb.wetDryMix = 0
        case 1:
            //音声読み上げ
            let talker = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: "リバーブ1")
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker.speak(utterance)
            reverb.wetDryMix = 40
        case 2:
            //音声読み上げ
            let talker = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: "リバーブ2")
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker.speak(utterance)
            reverb.wetDryMix = 70
        case 3:
            //音声読み上げ
            let talker = AVSpeechSynthesizer()
            let utterance = AVSpeechUtterance(string: "リバーブ3")
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            talker.speak(utterance)
            reverb.wetDryMix = 100
        default:
            reverb.wetDryMix = 0
        }
    }
    func voiceTagAlert() {
        // アラートを作成
        let alert = UIAlertController(
            title: "",
            message: "音声タグを追加しますか",
            preferredStyle: .alert)
        // アクションシートの親となる UIView を設定
        alert.popoverPresentationController?.sourceView = self.view
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "追加する", style: .default, handler: { action in
            
            self.showPostAlert()
        }))
        alert.addAction(UIAlertAction(title: "追加しない", style: .default, handler: { action in
            self.showPostAlert()
        }))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showPostAlert() {
        
        // アラートを作成
        let alert = UIAlertController(
            title: "",
            message: "保存しました",
            preferredStyle: .alert)
        // アクションシートの親となる UIView を設定
        alert.popoverPresentationController?.sourceView = self.view
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "再生リストに戻る", style: .default, handler: { action in
            self.finishActivity()
        }))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    func showDismissAlert() {
        
        // アラートを作成
        let alert = UIAlertController(
            title: "",
            message: "キャンセルしました",
            preferredStyle: .alert)
        // アクションシートの親となる UIView を設定
        alert.popoverPresentationController?.sourceView = self.view
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "再生リストに戻る", style: .default, handler: { action in
            self.finishActivity()
        }))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func finishActivity(){
        //次画面への遷移
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        //TODO: これだとTabBarControllerの先頭にしか飛べない
    }

}
