//
//  TimerBrain.swift
//  Skurring
//
//  Created by Marius Fagerhol on 22/02/17.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class Timerbrain {
    var theTimer = Timer()
    
    func startTimer(VC: UIViewController, selector: Selector) {
        theTimer = Timer.scheduledTimer(timeInterval: 1, target: VC, selector: selector, userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        theTimer.invalidate()
    }
}
