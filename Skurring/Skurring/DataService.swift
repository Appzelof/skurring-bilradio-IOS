//
//  DataService.swift
//  Skurring
//
//  Created by Marius Fagerhol on 09/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
import AssistantKit
import AudioToolbox

class DS {
    
    public static var dsInstance = DS()
    
    public var currentPlayingSong: Dictionary<String, String> = [
        "song": "Laster...",
        "artist": "Laster...",
        "radioChannel": "Laster..."
    ]
    
    let phoneVersion = Device.version
    
    public func checkDevice() {
        switch phoneVersion {
        case .phone4, .phone4S, .phone5, .phone5C, .phone5S, .phone6, .phone6S, .phone6Plus, .phone6SPlus, .phoneSE:
            doVibration(newerThan6sPlus: false)
        default:
            if self.checkIfIpad() {
                doVibration(newerThan6sPlus: false)
            } else {
                doVibration(newerThan6sPlus: true)
            }
        }
    }
    
    private func checkIfIpad() -> Bool {
        switch phoneVersion {
        case .pad1, .pad2, .pad3, .pad4, .padAir, .padAir2, .padMini, .padMini2, .padMini3, .padMini4, .padPro, .podTouch1, .podTouch2, .podTouch3, .podTouch4, .podTouch5, .podTouch6:
            return true
        default:
            return false
        }
    }
    
    private func doVibration(newerThan6sPlus: Bool) {
        if newerThan6sPlus {
            if #available(iOS 10.0, *) {
                let generator = UIImpactFeedbackGenerator.init(style: .medium)
                generator.impactOccurred();
            } else {
                oldVibration()
            }
        } else {
            oldVibration()
        }
    }
    
    private func oldVibration() {
        let vibrate = kSystemSoundID_Vibrate
        AudioServicesPlaySystemSound(vibrate)
    }
}
