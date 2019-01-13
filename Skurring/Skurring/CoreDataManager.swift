//
//  CoreDataManager.swift
//  Skurring
//
//  Created by Marius Fagerhol on 12/01/2019.
//  Copyright © 2019 Appzelof. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private var coreDataConfigurations: CoreDataConfigurations!
    private var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    
    init() {
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = appDelegate.persistentContainer.viewContext
        coreDataConfigurations = CoreDataConfigurations(context: context, appDelegate: appDelegate)
    }
    
    func saveOrReplaceRadioStation(radioStation: MainScreenRadioObjects) {
        self.coreDataConfigurations.saveOrReplaceRadioStation(radioStation: radioStation, radioImage: radioStation.image)
    }
    
    func getAllStations() -> [Radiostations] {
        return self.coreDataConfigurations.getAllStations()
    }
    
}
