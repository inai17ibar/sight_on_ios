//
//  AutoEditViewController.swift
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

class AutoEditViewController: ViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var sliderDelay: UISlider!
    let temp_data = TemporaryDataManager()
    //var player: AVAudioPlayer?
    // インスタンス変数
    var engine = AVAudioEngine()
    //playerNodeの準備
    var player = AVAudioPlayerNode()
    //revebNodeの準備
    //var reverb = AVAudioUnitReverb()
    //AVAudioUnitDelayの準備
    var delay = AVAudioUnitDelay()
    var audiolength = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let file_path = temp_data.loadDataPath()
        print(file_path)
        let fileUrl = URL(fileURLWithPath: file_path)        // オーディオファイルの読み込み
        
        do {
            let audioFile = try AVAudioFile(forReading: fileUrl)
            let audioFormat = audioFile.processingFormat
            let audioFrameCount = UInt32(audioFile.length)
            print(audioFile.length)
            print(audioFrameCount)
            let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            try! audioFile.read(into: audioFileBuffer)
            audiolength = Int(audioFile.length)
            //Delayの設定
            // 高域側のカットオフ周波数
            //audioFile.processingFormat.sampleRate
            delay.lowPassCutoff = 15000;    // Range: 10 -> (samplerate/2)
            delay.delayTime = 0;
            delay.feedback = 0;
            // AudioEngineにnodeを設定
            engine.attach(player)
            engine.attach(delay)
            
            engine.connect(player, to: delay, format: audioFile.processingFormat)
            engine.connect(delay, to: engine.outputNode, format: audioFile.processingFormat)
            
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
        let file_path = temp_data.loadDataPath()
        print(file_path)
        let fileUrl = URL(fileURLWithPath: file_path)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32  , sampleRate: 44100, channels: 1 , interleaved: true)
        /*do{
        let audioFile_write = try AVAudioFile(forWriting: fileUrl, settings: format.settings)
        //var audioPlayerNode = AVAudioPlayerNode() //or your Time pitch unit if pitch changed

        engine.outputNode.installTap(onBus: 0, bufferSize: 4096, format: nil) { (buffer, when) in
            
            if (audioFile_write.length) < (audiolength){//Let us know when to stop saving the file, otherwise saving infinitely
                audioFile_write.write(from: buffer)//let's write the buffer result into our file
                
            }else{
                self.engine.outputNode.removeTap(onBus: 0)//if we dont remove it, will keep on tapping infinitely
            }

        }
        }catch let error {
            print("AVAudioFile error:", error)
        }
        */
        
        /*do{
            let audioFile_write = try AVAudioFile(forWriting: fileUrl, settings: format.settings)
        }catch let error {
            print("AVAudioFile error:", error)
        }
        self.player.installTap(onBus: 0, bufferSize:AVAudioFrameCount(audiolength), format: player.outputFormat(forBus: 0), block: {(buffer, time) in
        let channels = UnsafeArray(start: buffer.floatChannelData, length: Int(buffer.format.channelCount))
        let floats = UnsafeArray(start: channels[0], length: Int(buffer.frameLength))
            
            for var i = 0; i < Int(self.audioBuffer.frameLength); i+=Int(self.engine.outputNode.outputFormatForBus(0).channelCount)
            {
                // process
                audioFile_write.write(from: buffer)
            }
        })
 */
        self.player.stop()
        
    }
    @IBAction func sliderDelayChanged(sender: UISlider) {
        delay.lowPassCutoff = sliderDelay.value
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
