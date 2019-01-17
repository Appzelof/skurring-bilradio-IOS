//
//  API_CALLS.swift
//  Skurring
//
//  Created by Marius Fagerhol on 17/01/2019.
//  Copyright © 2019 Appzelof. All rights reserved.
//

import FirebaseDatabase

class API_CALLS {
    
    
    let database = Database.database().reference()
    
    func getAllNorwegianChannels(when completed: @escaping (_ channels: [RadioPlayer]) -> Void) {
        database.child("Norway").observeSingleEvent(of: .value, with: { (snapshot) in
            if let allNorwegianStations = RadioPlayer.init(dataFromFirebase: snapshot.children.allObjects) {
                completed(allNorwegianStations.parsedRadioStations)
            } 
        })
    }
    
}
