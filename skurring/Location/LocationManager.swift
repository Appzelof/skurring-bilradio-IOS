//
//  LocationManager.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationHandlerDelegate: class {
    func speedDidUpdate(speed: String)
    func coordinatesDidUpdate(lat: Double, lon: Double)
}
extension LocationHandlerDelegate {
    func speedDidUpdate(speed: String) {}
    func coordinatesDidUpdate(lat: Double, lon: Double) {}
}

class LocationManager: NSObject {

    static let shared = LocationManager()

    weak var locationDelegate: LocationHandlerDelegate?

    private let locationManager = CLLocationManager()

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

        let latitude = lastKnownLocation.latitude
        let longitude = lastKnownLocation.longitude

        let convertedSpeed = Int(location.speed * 3600 / 1000)
        let isNegative = convertedSpeed < 0
        let kilometerPerHour = !isNegative ? convertedSpeed : 0


// MARK: - lat and lon should only have 4 decimals.Œ
        locationDelegate?.coordinatesDidUpdate(lat: latitude, lon: longitude)
        locationDelegate?.speedDidUpdate(speed: "\(kilometerPerHour)")
    }
}
