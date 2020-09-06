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

final class NetworkManager {
    static let shared = NetworkManager()
    private var radioStations = [RadioStation]()
    private let firebaseData = FirebaseDataFetcher()
    private let imageProvider = ImageProvider()

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

    func fetchRadioStation(at completion: @escaping (RadioStation?) -> Void) {
        firebaseData.fetchData(completion: completion)
    }
}

