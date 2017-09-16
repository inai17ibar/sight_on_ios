//
//  SoundPlayer.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/08/19.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

protocol SoundPlayerDelegate: class {
    func updateMessage(text: String)
    func updatePlayBtnsTitle(text: String)
}

class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    
    weak var delegate: SoundPlayerDelegate? = nil
    
    var audioPlayer = AVAudioPlayer()
    
    var playingUrl:URL?
    
    var hasInit:Bool!
    
    override init()
    {
        // 再生と録音の機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback) //SoloAmbient
        try! session.setActive(true)
    }
    
    public func initPlayer(url: URL)
    {
        do{
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            //print("set audio url")
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
            //setting
            audioPlayer.volume = 1.0
            audioPlayer.prepareToPlay()
            
            //delegate?.updatePlayBtnsTitle(text: "Play")
            print("init player")
            playingUrl = url
            hasInit = true
        }catch{
            print("Error: cannot init audioPlayer")
            hasInit = false
        }
    }
    
    public func play(url: URL)
    {
        if url == getSoundURL() {
            print("Alert: Already has playing")
            return
        }
        initPlayer(url: url)
        play()
    }
    
    public func play()
    {
        if !hasInit {
            return
        }
        print("play")
        audioPlayer.play()
        self.delegate?.updatePlayBtnsTitle(text: "Stop")
    }
    
    public func stop()
    {
        print("stop")
        audioPlayer.stop()
        self.delegate?.updatePlayBtnsTitle(text: "Play")
    }
    
    public func isPlaying() -> Bool
    {
        if playingUrl == nil
        {
            return false
        }
        return audioPlayer.isPlaying
    }
    
    public func getSoundURL() -> URL? //nilがはいることを保証する
    {
        return playingUrl
    }
    
    public func setVolume(volume: Float)
    {
        audioPlayer.volume = volume
    }
    
    //再生終了時の呼び出しメソッド
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        self.delegate?.updatePlayBtnsTitle(text: "Finish")
        print("finish")
    }
    
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {
        print("Decoding Error on audioPlayer")
    }
}
