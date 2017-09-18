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
        try! session.setCategory(AVAudioSessionCategorySoloAmbient) //AVAudioSessionCategoryPlayback) アプリを落としても再生するときPlayback
        try! session.setActive(true)
    }
    
    public func initPlayer(url: URL)
    {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
            audioPlayer.prepareToPlay()
            
            print("[SoundPlayer] init player")
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
        print("[SoundPlayer] play")
        audioPlayer.play()
        self.delegate?.updatePlayBtnsTitle(text: "Stop")
    }
    
    public func stop()
    {
        print("[SoundPlayer] stop")
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
        print("[SoundPlayer] finish")
    }
    
    // デコード中にエラーが起きた時に呼ばれるメソッド
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?)
    {
        print("[SoundPlayer] Decoding Error on audioPlayer")
    }
}
