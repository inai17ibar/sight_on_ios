//
//  SoundPlayer.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/08/19.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

protocol SoundPlayerDelegate {
    func updateMessage(text: String)
    func updatePlayBtnsTitle(text: String)
}

class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    
    var delegate: SoundPlayerDelegate!
    
    //singleton
    //static let sharedInstance = SoundPlayer()
    var audioPlayer:AVAudioPlayer!
    var playingUrl:URL?
    var hasInit:Bool!
    
    override init()
    {
        
    }
    
    public func initPlayer(url: URL)
    {
        playingUrl = url
        
        // 再生と録音の機能をアクティブにする
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategorySoloAmbient)
        try! session.setActive(true)
        
        do{
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self
            //setting
            audioPlayer.volume = 5.0
            
            //delegate?.updatePlayBtnsTitle(text: "Play")
            print("init player")
            hasInit = true
        }
        catch{
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
        delegate?.updatePlayBtnsTitle(text: "Stop")
    }
    
    public func stop()
    {
        print("stop")
        audioPlayer.stop()
        delegate?.updatePlayBtnsTitle(text: "Play")
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
        //delegate?.updateMessage("")
        delegate.updatePlayBtnsTitle(text: "Finish")
        print("finish")
    }
    
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {
        print("Decoding Error on audioPlayer")
    }
}
