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
    
    //Metode som kan ta i mot og lagre data i coreData (Denne skal primært bli brukt mot parset data fra firebase)
    func saveStationsFromDatabase(dbEntity: String, radioName: String, radioUrl: String, radioImage: NSData?) {
        
        //Setter entity så vi vet hvor dataen skal bli lagret
        let entity = NSEntityDescription.entity(forEntityName: dbEntity, in: context)
        let newValue = NSManagedObject.init(entity: entity!, insertInto: context)
        
        //Lagrer verdier fra denne funksjones parametere
        newValue.setValue(radioName, forKey: radioName)
        newValue.setValue(radioUrl, forKey: radioUrl)
        newValue.setValue(radioImage, forKey: "radioImage")
        
        do {
            try context.save()
        } catch {
            print("Could not save station")
        }
    }
    
    //Denne metoden henter ut alle data som er lagret i "DBStations" i data modellen
    func getAllStationsFromCoreData(entityName: String, sortBy: String) -> [Any?] {
        //Ny liste for radiostatsjonene
        var objectList = [NSFetchRequestResult]()
        
        //Request
        let request = NSFetchRequest<DBstations>(entityName: entityName)
        
        //Ny fetch requestController for å hente data
        request.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true, selector: nil)]
        let fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchController.performFetch()
            objectList = fetchController.fetchedObjects!
        } catch {
            fatalError("Could not fetch data")
        }
        
        return objectList
    }
    
}
