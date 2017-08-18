//
//  ManualEditViewController.swift
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

class ManualEditViewController: ViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var sliderReverb: UISlider!

    let temp_data = TemporaryDataManager()
    //var player: AVAudioPlayer?
    // インスタンス変数
    var engine = AVAudioEngine()
    //playerNodeの準備
    var player = AVAudioPlayerNode()
    //revebNodeの準備
    var reverb = AVAudioUnitReverb()
    //AVAudioUnitDelayの準備
    var delay = AVAudioUnitDelay()

    //var filePath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let file_path = temp_data.loadDataPath()
        print("preparing")

        //print(file_path)
        //filePath = NSHomeDirectory() + "/Documents/temp_data.m4a"
        //let audioUrl = URL(fileURLWithPath: file_path)
        //let asset = AVAsset(url: URL(fileURLWithPath: filePath))
        //let fileUrl = URL(fileURLWithPath: file_path)        // オーディオファイルの読み込み
        let fileUrl = URL(fileURLWithPath: file_path.substring(to: file_path.index(file_path.endIndex, offsetBy: -4))+"_autoedit.wav")
        do {
            print(fileUrl)
            let audioFile = try AVAudioFile(forReading: fileUrl)
            // initializing the AVAudioPCMBuffer
            //let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: audioFile.fileFormat.sampleRate, channels: 1, interleaved: false)
            //let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 1024)
            //try! audioFile.read(into: buf)
            
            let audioFormat = audioFile.processingFormat
            let audioFrameCount = UInt32(audioFile.length)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            
            try! audioFile.read(into: audioFileBuffer)
            

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
            engine.attach(player)
            engine.attach(reverb)
            engine.attach(delay)
            engine.connect(player, to: delay, format: audioFile.processingFormat)
            engine.connect(delay, to: reverb, format: audioFile.processingFormat)
            engine.connect(reverb, to: engine.outputNode, format: audioFile.processingFormat)
            
            engine.prepare()
            do{
                try! engine.start()
            }
            // playerにオーディオファイルを設定
            /*self.player.scheduleFile(audioFile, at: nil, completionHandler: { () -> Void in
             // 再生が終了すると呼ばれる
             print("Completion")
             })*/
            self.player.scheduleBuffer(audioFileBuffer, at: nil, options:.loops, completionHandler: { () -> Void in
                // 再生が終了すると呼ばれる
                print("Completion")
            })
            
            // 再生開始
            self.player.play()
        } catch let error {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender : Any) {
        self.player.stop()
    }
    
    @IBAction func sliderReverbChanged(sender: UISlider) {
        reverb.wetDryMix = sliderReverb.value
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
