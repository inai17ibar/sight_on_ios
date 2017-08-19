//
//  RecordViewController.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/07/22.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: ViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var filePath:String!
    var audioPlayer:AVAudioPlayer!
    
    let dataManager = TemporaryDataManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            fatalError("初期設定にエラー")
        }
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let now = Date()
        return formatter.string(from: now)
    }
    
    @IBAction func buttonTapped(_ sender : Any) {
        
        if(audioRecorder.isRecording)
        {
            print("stop recording")
            button.setTitle("Record", for: .normal)
            audioRecorder.stop()
            saveRecordData()
            initPlayer(url: URL(fileURLWithPath: dataManager.loadDataPath()))
            //dataManager.saveEditDataPath(filePath.substring(to: filePath.index(filePath.endIndex, offsetBy: -4))+"_autoedit.wav")
        }
        else{
            print("start recording")
            button.setTitle("Now recording...", for: .normal)
            audioRecorder.record()
        }
    }
    
    func saveRecordData()
    {
        dataManager.saveDataPath(filePath)
    }
    
    @IBAction func playButtonTapped(_ sender : Any) {
        
        if audioPlayer == nil{
            return
        }
        
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            playButton.setTitle("Play", for: .normal)
        }
        else{
            print("play")
            //音量
            audioPlayer.volume = 2.0
            audioPlayer.play()
            playButton.setTitle("Playing...", for: .normal)
        }
    }
    
    func initPlayer(url: URL)
    {
        do{
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
        }
        catch{
            print("Error: cannot init audioPlayer")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //再生終了時の呼び出しメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        playButton.setTitle("Finish", for: .normal)
    }
    
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {
        print("Error")
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
