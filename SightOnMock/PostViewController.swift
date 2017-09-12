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
    let buttonLabel: [String] = ["Raw", "Reverb1", "Reverb2", "Reverb3"]
    var buttonidx=0
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    let temp_data = TemporaryDataManager()
    let database = DatabaseAccessManager()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            //print(fileUrl)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func post()
    {
        saveData()
        let file_path = temp_data.loadDataPath()
        //let url = URL(fileURLWithPath: file_path)
        print("post")
        database.create(file_path, dataName: getNowClockString(), userId: 1, tags:["fun", "happy", "hot"])
        database.add()
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMdd"
        let now = Date()
        return formatter.string(from: now)
    }

    func saveData(){
        let save_file_path = file_path
        let fileUrl_write = URL(fileURLWithPath: save_file_path)
        //print(fileUrl_write)
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
                    //print("Save done")
                    self.player.stop()
                    self.engine.stop()
                    goFlag = true;
                }
                
            })
        }catch let error {
            print("AVAudioFile error:", error)
        }
        while(!goFlag){
            usleep(200000)
        }
        
    }
    @IBAction func buttonTapped(_ sender : Any)
    {
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            //print("on haptic!")
        }
        
        postButton.setTitle("保存されました．フィード画面に移動します.", for: .normal)
        post()

        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func dismissButtonTapped(_ sender : Any)
    {
        if #available(iOS 10.0, *), let generator = feedbackGenerator as? UIImpactFeedbackGenerator {
            generator.impactOccurred()
            //print("on haptic!")
        }
        dismissButton.setTitle("保存をキャンセルしました．録音画面に戻ります.", for: .normal)
        print("dismiss")

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func editbuttonTapped(_ sender : Any) {
        buttonidx += 1;
        if buttonidx>=buttonLabel.count{
            buttonidx=0;
        }
        Editbutton.setTitle(buttonLabel[buttonidx], for: .normal)
        switch buttonidx {
        case 0:
            reverb.wetDryMix = 0
        case 1:
            reverb.wetDryMix = 40
        case 2:
            reverb.wetDryMix = 70
        case 3:
            reverb.wetDryMix = 100
        default:
            reverb.wetDryMix = 0
        }
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
