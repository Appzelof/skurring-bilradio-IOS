//
//  CoreDataConfigurations.swift
//  Skurring
//
//  Created by Marius Fagerhol on 12/01/2019.
//  Copyright © 2019 Appzelof. All rights reserved.
//

import UIKit
import CoreData

class CoreDataConfigurations {
    
    private var savedRadioStationObject: Radiostations!
    private var context: NSManagedObjectContext!
    private var appDelegate: AppDelegate!
    
    init(context: NSManagedObjectContext, appDelegate: AppDelegate) {
        self.context = context
        self.appDelegate = appDelegate
    }
    
    /*Sjekker om radiostasjonen eksisterer og sletter dem om den gjør*/
    private func checkIfSpotIsTaken(spot: Int) {
        var spotIsTaken = false
        var duplicate: Radiostations!
        for station in getAllStations() {
            let spotInt = Int(station.radioSpot)
            spotIsTaken = spot == spotInt
            if spotIsTaken {
                duplicate = station
                self.context.delete(duplicate)
                self.appDelegate.saveContext()
            }
        }
    }
    
    /*Lagrer ny radiostasjon på plassen den ble klikket på, på viewController(MainPage)*/
    func saveOrReplaceRadioStation(radioStation: MainScreenRadioObjects, radioImage: UIImage) {
        checkIfSpotIsTaken(spot: radioStation.radioSpot)
        saveRadioStation(radioStation: radioStation, radioImage: radioImage)
    }
    
    /*Lagrer stasjon*/
    private func saveRadioStation(radioStation: MainScreenRadioObjects, radioImage: UIImage) {
        let _ = Radiostations.init(radioRequestedToSave: radioStation, radioImageRequestedToSave: radioImage, context: self.context)
        self.appDelegate.saveContext()
    }
    
    /*Henter ut alle stasjonene*/
    func getAllStations() -> [Radiostations] {
        let fetchRequest = NSFetchRequest<Radiostations>(entityName: "Radiostations")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "radioSpot", ascending: true)]
        let stations = try! self.context.fetch(fetchRequest)
        return stations
    }
    
    
}
