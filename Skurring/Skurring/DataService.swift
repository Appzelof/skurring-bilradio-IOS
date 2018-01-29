//
//  DataService.swift
//  Skurring
//
//  Created by Marius Fagerhol on 09/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation
class DS {
    
    public static var dsInstance = DS()
    
    
    public var currentPlayingSong: Dictionary<String, String> = [
        "song": "Laster...",
        "artist": "Laster...",
        "radioChannel": "Laster..."
    ]
    
    
}
