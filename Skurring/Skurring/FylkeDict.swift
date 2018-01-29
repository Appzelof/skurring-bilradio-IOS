//
//  FylkeDict.swift
//  Skurring
//
//  Created by Marius Fagerhol on 09/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

public func getFylkeID(fylke: String) -> Int {
    let fylkerDict: Dictionary<String, Int> = [
        "Akershus": 2,
        "Aust-Agder": 9,
        "Buskerud": 6,
        "Finnmark": 20,
        "Hedmark": 4,
        "Hordaland": 12,
        "Møre og Romsdal": 15,
        "Nord-Trøndelag": 17,
        "Nordland": 18,
        "Oppland": 5,
        "Oslo": 3,
        "Rogaland": 11,
        "Sogn og Fjordane": 14,
        "Sør-Trøndelag": 16,
        "Telemark": 8,
        "Troms": 19,
        "Vest-Agder": 10,
        "Vestfold": 7,
        "Østfold": 1
    ]
    if let fylkeID = fylkerDict[fylke] {
        return fylkeID
    } else {
        return 0
    }
}
