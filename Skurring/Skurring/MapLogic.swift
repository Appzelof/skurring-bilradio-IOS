//
//  VegvesenKartVC.swift
//  Skurring
//
//  Created by Marius Fagerhol on 16/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
import MapKit

class MapLogic: NSObject, MKMapViewDelegate {
    
    var vegMeldingInfo: VegvesenCollectionObject!
    var multiLocation: Bool!
    private var firstLocation: CLLocationCoordinate2D?
    private var secondLocation: CLLocationCoordinate2D?
    private var locations: [CLLocationCoordinate2D] = []
    private var multiLocations: [[CLLocationCoordinate2D]]!
    var vegVesenMultiObjects: [VegvesenCollectionObject]!
    private var fromViewController: UIViewController!
    
    init(fromViewController: UIViewController) {
        self.fromViewController = fromViewController
    }
    
    private func configureMap(map: MKMapView) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        self.addAnnotation(multiLocation: true, span: span, map: map)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
       // let myAnnotation = MKAnnotationView.init(annotation: annotation, reuseIdentifier: "custom")
        let myAnnotation = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "custom")
        myAnnotation.animatesDrop = true
        //myAnnotation.image = UIImage.init(named: "VegMeldinger_liten")
        return myAnnotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let theAnnotation = view.annotation {
            self.addOrCheck(map: mapView, add: false, location: theAnnotation.coordinate)
        }
    }
    
    private func addOrCheck(map: MKMapView, add: Bool, location: CLLocationCoordinate2D?) {
        var index = 0
        for mLocations in self.multiLocations {
            if add {
                let annotation = MyCustomPinAnnotation.init(coordinate: mLocations[index], identifier: "custom")
                map.addAnnotation(annotation)
            } else {
                if location!.latitude == mLocations[index].latitude && location!.longitude == mLocations[index].longitude {
                    self.fromViewController.present(presentAnnotationInformation(title: self.vegVesenMultiObjects[index].getTitle.formatDescription(), subTitle: self.vegVesenMultiObjects[index].getDesc.formatDescription(), deselectAnnotation: {
                    }), animated: true, completion: nil)
                }
            }
            
            index += 1
        }
    }
    
    private func addAnnotation(multiLocation: Bool, span: MKCoordinateSpan, map: MKMapView) {
        self.addOrCheck(map: map, add: true, location: nil)
        if multiLocations.count > 0 {
            let location = CLLocationCoordinate2DMake(map.userLocation.coordinate.latitude, map.userLocation.coordinate.longitude)
            let region = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: true)
        }
    }
    
  
    func retrieveAndMakeMultiLocations(vegvesenObjects: [VegvesenCollectionObject], map: MKMapView) {
        multiLocations = []
        self.vegVesenMultiObjects = vegvesenObjects
        for vegObj in vegvesenObjects {
            vegMeldingInfo = vegObj
            formatLocations()
        }
        self.configureMap(map: map)
    }
    
    private func formatLocations() {
        if !vegMeldingInfo.getLocationArray.isEmpty {
            var splittetString = vegMeldingInfo.getLocationArray[0].split(separator: " ")
            if let latitude = Double(splittetString[0]), let longitude = Double(splittetString[1]) {
                firstLocation = CLLocationCoordinate2DMake(latitude, longitude)
                locations.append(firstLocation!)
            }
            
            if vegMeldingInfo.getLocationArray.count > 1 {
                splittetString = vegMeldingInfo.getLocationArray[1].split(separator: " ")
                if let latitude = Double(splittetString[0]), let longtitude = Double(splittetString[1]) {
                    secondLocation = CLLocationCoordinate2DMake(latitude, longtitude)
                    locations.append(secondLocation!)
                }
            }
            
            self.multiLocations.append(locations)
            
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.fromViewController.dismiss(animated: true, completion: nil)
    }
    
    
   
    
}
