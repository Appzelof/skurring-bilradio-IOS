//
//  NetworkManager.swift
//  skurring
//
//  Created by Daniel Bornstedt on 09/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private var radioStations = [RadioStation]()
    private let firebaseData = FirebaseDataFetcher()
    private let imageProvider = ImageProvider()

    func fetchRadioData(at completion: @escaping ([RadioStation]) -> Void) {
        if radioStations.isEmpty {
            firebaseData.fetchData { (station) in
                guard
                    let station = station,
                    let name = station.name,
                    let radioCountry = station.radioCountry,
                    let imageUrl = station.imageURL,
                    let radioURL = station.radioURL,
                    let radioHQURL = station.radioHQURL

                    else { return }

                self.radioStations.append(
                    RadioStation(
                        imageURL: imageUrl,
                        name: name,
                        radioCountry: radioCountry,
                        radioURL: radioURL,
                        radioHQURL: radioHQURL
                    )
                )
                completion(self.radioStations)
            }
        } else {
            completion(self.radioStations)
        }
    }

    func fetch<T: Decodable>(url: URL, model: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { $0 }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }

    func fetchRadioImage(url: String, completion: @escaping (UIImage) -> ()) {
        imageProvider.fetchImage(url: url, completion: completion)
    }
}

