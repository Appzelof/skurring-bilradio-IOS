//
//  FirebaseData.swift
//  skurring
//
//  Created by Daniel Bornstedt on 13/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class FirebaseDataFetcher {
    let ref: DatabaseReference!

    init() { ref = Database.database().reference(fromURL: "https://skurring-bilradio.firebaseio.com/") }

    func fetchData(completion: @escaping (RadioStation?) -> Void) {
        ref.observeSingleEvent(of: .childAdded) { (snapshot) in
            guard snapshot.exists() else { return }
            let value = snapshot.value as? NSDictionary
            if let value = value {
                let items = value.allKeys as? [String] ?? []
                for stationName in items {
                    if snapshot.hasChildren() {
                        let radioDictionary = snapshot.childSnapshot(forPath: stationName).value as? NSDictionary
                        let radioName = radioDictionary?.value(forKey: "name") as? String ?? ""
                        let radioImage = radioDictionary?.value(forKey: "imageURL") as? String ?? ""
                        let radioCountry = radioDictionary?.value(forKey: "radioCountry") as? String ?? ""
                        let radioURL = radioDictionary?.value(forKey: "radioURL") as? String ?? ""
                        let radioHQURL = radioDictionary?.value(forKey: "radioHQURL") as? String ?? ""

                        let radioStation = RadioStation(
                            imageURL: radioImage,
                            name: radioName,
                            radioCountry: radioCountry,
                            radioURL: radioURL,
                            radioHQURL: radioHQURL
                        )
                        DispatchQueue.main.async {
                            completion(radioStation)
                        }
                    }
                }
            }
        }
    }
}
