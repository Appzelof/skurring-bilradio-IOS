//
//  SaveData.swift
//  Skurring
//
//  Created by Marius Fagerhol on 25/02/17.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation

func saveData() {
    let stationsData = NSKeyedArchiver.archivedData(withRootObject: MainScreenRadioObjects.mainScreenRadioObjectsArray)
    UserDefaults.standard.set(stationsData, forKey: "SavedStations")
    UserDefaults.standard.synchronize()
}

func loadData() {
    if let LoadedStations = UserDefaults.standard.object(forKey: "SavedStations") as? Data {
        if let TheStationsArray = NSKeyedUnarchiver.unarchiveObject(with: LoadedStations) as? [MainScreenRadioObjects] {
            MainScreenRadioObjects.mainScreenRadioObjectsArray = TheStationsArray
        }
    }
}
