//
//  TtsManager.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/09/03.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit
import AVFoundation

final class TtsManager: NSObject, AVSpeechSynthesizerDelegate {
    
    static let sharedInstance = TtsManager()
    
    var texts = [String]()
    let talker = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        talker.delegate = self
    }
    
    func append(text: String) {
        texts.append(text)
        if texts.count == 1 {
            play(text: texts[0])
        }
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if texts.count > 0 {
            texts.removeFirst()
            if texts.count > 0 {
                play(text: texts[0])
            }
        } else {
            // speech finished
        }
    }
    
    func clear() {
        texts.removeAll()
        if talker.isSpeaking {
            talker.stopSpeaking(at: .immediate)
        }
    }
    
    private func play(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        talker.speak(utterance)
    }
    
}
