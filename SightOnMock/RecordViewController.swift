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
        initRecorder()
    }

    func initRecorder()
    {
        // 録音ファイルを指定する
        filePath = NSHomeDirectory() + "/Documents/temp_data_"+getNowClockString()+".wav"
        let url = URL(fileURLWithPath: filePath)

        // 再生と録音の機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)

        // 録音の詳細設定
        let recordSetting : [String : AnyObject] = [
            //AVFormatIDKey : UInt(kAudioFormatAppleLossless) as AnyObject,
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
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let now = Date()
        return formatter.string(from: now)
    }

    @IBAction func buttonTapped(_ sender : Any) {

        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            print("on haptic!")
        }

        if(audioRecorder.isRecording)
        {
            print("stop recording")
            button.setTitle("Record", for: .normal)
            audioRecorder.stop()
            saveRecordData()

            //いつ初期化するのがいいか？？
            soundPlayer.initPlayer(url: URL(fileURLWithPath: dataManager.loadDataPath()))

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AutoEdit")
            self.present(nextViewController, animated:true, completion:nil)
        }
        else{
            print("start recording")
            initRecorder()
            let instruction_text = "録音中です．ダブルタップで録音を終了します．"
            button.setTitle(instruction_text, for: .normal)
            audioRecorder.record()
        }
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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
