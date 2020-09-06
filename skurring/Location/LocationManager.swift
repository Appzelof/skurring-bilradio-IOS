//
//  LocationManager.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationKeys: String {
    case kilometersPerHour = "KilometersPerHour"
    case coordinates = "Coordinates"
}

final class LocationManager: NSObject {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    private lazy var kilometersPerHourDict: [LocationKeys: String] = [:]
    private lazy var coordinatesDict: [LocationKeys: [Float]] = [:]

     private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startUpdatingLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard
            let location = locationManager.location,
            let lastKnownLocation = locations.last?.coordinate
            else { return }

        let latitude = Float(lastKnownLocation.latitude)
        let longitude = Float(lastKnownLocation.longitude)

        let convertedSpeed = Int(location.speed * 3600 / 1000)
        let isNegative = convertedSpeed < 0
        let kilometersPerHour = !isNegative ? convertedSpeed : 0

        coordinatesDict[.coordinates] = [latitude, longitude]
        kilometersPerHourDict[.kilometersPerHour] = kilometersPerHour.description

        NotificationCenter.default.post(
            name: .kilometersPerHour,
            object: nil,
            userInfo: kilometersPerHourDict
        )

        NotificationCenter.default.post(
            name: .coordinates,
            object: nil,
            userInfo: coordinatesDict
        )
    }
}
