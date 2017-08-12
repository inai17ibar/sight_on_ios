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

    var player: AVAudioPlayer?
    var filePath: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        filePath = NSHomeDirectory() + "/Documents/temp_data.m4a"
        //filePath = Bundle.main.path(forResource: "yurakucho_muzhirusi", ofType:"m4a")
        let audioUrl = URL(fileURLWithPath: filePath)
        //let asset = AVAsset(url: URL(fileURLWithPath: filePath))

        // インスタンス変数
        // エンジンの生成
        let audioEngine = AVAudioEngine()
        // Playerノードの生成
        let player = AVAudioPlayerNode()
        do {
            // オーディオファイルの取得
            let audioFile = try AVAudioFile(forReading: audioUrl)
            // エンジンにノードをアタッチ
            audioEngine.attach(player)
            // メインミキサの取得
            let mixer = audioEngine.mainMixerNode
            // Playerノードとメインミキサーを接続
            audioEngine.connect(player,
                                to: mixer,
                                format: audioFile.processingFormat)
            // プレイヤのスケジュール
            player.scheduleFile(audioFile, at: nil) {
                print("complete")
            }
            // エンジンの開始
            try audioEngine.start()
            // オーディオの再生
            player.play()
        } catch let error {
            print(error)
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
