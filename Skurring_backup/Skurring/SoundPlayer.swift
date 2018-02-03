//
//  SoundPlayer.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 03/09/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
    
    private var _soundFile: String!
    private var _fileType: String!
    var player = AVAudioPlayer()
    
    var soundFile: String {
        if _soundFile == nil {
            _soundFile = ""
        }
        return _soundFile
    }
    
    var fileType: String {
        if _fileType == nil {
            _fileType = ""
        }
        return _fileType
    }
    
    init(soundFile: String, fileType: String) {
        _soundFile = soundFile
        _fileType = fileType
        
        let path = Bundle.main.path(forResource: soundFile, ofType: fileType)
        
        do {
            
           try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            player.prepareToPlay()
            
        } catch {
            let error = NSError.self
            print(error)
        }
        
    }
    
    func playSound() {
        if player.isPlaying{
            player.stop()
        }else {
            player.play()
        }
    }
    
    
    
}
