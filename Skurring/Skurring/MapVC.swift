//
//  SettingsVC.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 24.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook


class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var bckBtn: UIButton!
    
    private var vegTrafikkInfo: [VegvesenCollectionObject]!
    private var lastSelectedMessage: VegvesenCollectionObject!
    private var hasDownloadedVegInfo: Bool!
    private let manager = CLLocationManager()
    static var formatedVegTrafikkDesc: NSCache = NSCache<NSString, NSMutableAttributedString>()
    static var formatedVegTrafikkTitle: NSCache = NSCache<NSString, NSMutableAttributedString>()
    private var mapLogic: MapLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vegTrafikkInfo = []
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            startUpdateLocationAndMap()
        default:
            break
        }
      
        self.bckBtn.imageView?.contentMode = .scaleAspectFit
        
    }
    
    private func startUpdateLocationAndMap() {
        setupManager()
        hasDownloadedVegInfo = false
        self.mapLogic = MapLogic.init(fromViewController: self)
        self.map.delegate = self.mapLogic
        self.removeAllAnnoationsFromMap()
    }
    
    func removeAllAnnoationsFromMap() {
        self.map.removeAnnotations(self.map.annotations)
    }
    
    
    private func setupManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.pausesLocationUpdatesAutomatically = true
        
        map.showsUserLocation = true
        map.userLocation.title = "Min plassering"
    }

    private func updateButtonUI(btn: UIButton) {
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.startUpdateLocationAndMap()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            let location = locations[0]
            if !self.hasDownloadedVegInfo {
                self.hasDownloadedVegInfo = true
                CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                    if error == nil {
                        if let placemark = placemarks?[0] {
                            if let fylke = placemark.administrativeArea {
                                let vegObj = XMLVegvesen.init(fylke: fylke)
                                vegObj.beginParsing(Completion: { (objectArray) in
                                    self.vegTrafikkInfo = objectArray
                                    DispatchQueue.main.sync {
                                        self.mapLogic.retrieveAndMakeMultiLocations(vegvesenObjects: self.vegTrafikkInfo, map: self.map)
                                    }
                                })
                            }
                        }
                    } else {
                        self.present(tooManyTraficRequests(), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func dismissVC(_ sender: UIButton!) {
        self.manager.stopUpdatingLocation()
        self.dismiss(animated: true, completion: nil)
    }
    
}
