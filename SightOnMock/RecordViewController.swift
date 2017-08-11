//
//  RecordViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: ViewController {

    @IBOutlet weak var button: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 初期化ここから
        // 録音ファイルを指定する
        let filePath = NSHomeDirectory() + "/Documents/test.m4a"
        let url = URL(fileURLWithPath: filePath) //URL(fileURLWithPath: sound!.dataPath)
        
        // 再生と録音の機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
        
        // 録音の詳細設定
        let recordSetting : [String : AnyObject] = [
            AVFormatIDKey : UInt(kAudioFormatAppleLossless) as AnyObject, 
            AVEncoderAudioQualityKey : AVAudioQuality.min.rawValue as AnyObject,
            AVEncoderBitRateKey : 16 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey: 44100.0 as AnyObject
        ]
        
        // 仕上げ
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSetting)
        } catch {
            fatalError("初期設定にエラー")
        }
        // 初期化ここまで
    }
    
    @IBAction func buttonTapped(_ sender : Any) {
        
        if(audioRecorder.isRecording){
            audioRecorder.stop()
            print("stop recording")
        }
        else{
            audioRecorder.record()
            print("start recording")
        }
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
