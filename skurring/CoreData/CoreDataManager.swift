//
//  CoreDataManager.swift
//  skurring
//
//  Created by Daniel Bornstedt on 18/11/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    let appDelegate: AppDelegate?
    let managedContext: NSManagedObjectContext?

    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
    }

    func saveChannel(radioName: String,
                     radioCountry: String,
                     radioURL: String,
                     radioHQURL: String,
                     radioImage: Data,
                     buttonTag: Int) {

        guard let context = managedContext else { return }
        if let entity = NSEntityDescription.entity(forEntityName: ConstantHelper.entityName, in: context) {
            let radioChannel = NSManagedObject(entity: entity, insertInto: context)
            radioChannel.setValue(radioName, forKey: ConstantHelper.radioName)
            radioChannel.setValue(radioCountry, forKey: ConstantHelper.radioCountry)
            radioChannel.setValue(radioURL, forKey: ConstantHelper.radioURL)
            radioChannel.setValue(radioHQURL, forKey: ConstantHelper.radioHQURL)
            radioChannel.setValue(radioImage, forKey: ConstantHelper.radioImage)
            radioChannel.setValue(buttonTag, forKey: ConstantHelper.buttonTag)
        }

        deleteDuplicatesAndSaveData(context: context, id: buttonTag)
    }

    private func deleteDuplicatesAndSaveData(context: NSManagedObjectContext, id: Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ConstantHelper.entityName)
        let predicate = NSPredicate(format: "\(ConstantHelper.buttonTag) = %@", "\(id)")
        fetchRequest.predicate = predicate
        do {
            guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
            for stations in results {
                context.delete(stations)
            }
            try context.save()
        } catch let error as NSError {
            print("\(error)")
        }
    }

    func fetchData() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ConstantHelper.entityName)
        guard let context = managedContext else { return nil }
        do {
            let data = try context.fetch(fetchRequest)
            return data
        } catch let error as NSError {
            print("\(error)")
        }
        return nil
    }

    func deleteData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ConstantHelper.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        guard let context = managedContext else { return }
        do {
            try context.execute(deleteRequest)

        } catch let error as NSError {
            print("\(error)")
        }
    }
}


