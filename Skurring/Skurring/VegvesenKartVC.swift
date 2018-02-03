//
//  VegvesenKartVC.swift
//  Skurring
//
//  Created by Marius Fagerhol on 16/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
import MapKit

class VegvesenKartVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    
    var vegMeldingInfo: VegvesenCollectionObject!
    private var firstLocation: CLLocationCoordinate2D?
    private var secondLocation: CLLocationCoordinate2D?
    private var locations: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.imageView?.contentMode = .scaleAspectFit
        map.delegate = self
        map.showsUserLocation = true
        formatLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfThereIsAnyLocation()
        configureMap()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer.init(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
   
    
    private func configureMap() {
        if !locations.isEmpty {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let location = CLLocationCoordinate2DMake(locations[0].latitude, locations[0].longitude)
            let region = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: true)
            addAnnotation(location: location)
            drawLineBetweenAnnotations()
        }
    }
    
    
    private func addAnnotation(location: CLLocationCoordinate2D) {
        for loc in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = loc
            annotation.title = vegMeldingInfo.getTitle
            annotation.subtitle = vegMeldingInfo.getDesc.formatDescription()
            map.addAnnotation(annotation)
        }
    
    }
    
    private func drawLineBetweenAnnotations() {
        if locations.count > 1 {
            let sourceLocation = CLLocationCoordinate2D.init(latitude: locations[0].latitude, longitude: locations[0].longitude)
            let destinationLocation = CLLocationCoordinate2D.init(latitude: locations[1].latitude, longitude: locations[1].longitude)
            
            let sourcePlacemark = MKPlacemark.init(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark.init(coordinate: destinationLocation, addressDictionary: nil)
            
            let sourceMapItem = MKMapItem.init(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem.init(placemark: destinationPlacemark)
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            
            let directions = MKDirections.init(request: directionRequest)
            
            directions.calculate(completionHandler: { (response, error) in
                if error == nil {
                    if let theResponse = response {
                        if !theResponse.routes.isEmpty {
                            let route = theResponse.routes[0]
                            self.map.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                            let rect = route.polyline.boundingMapRect
                            self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                        }
                    }
                } else {
                    print("Error occured: \(error.debugDescription)")
                }
            })
        }
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
        }
    }
    
    private func checkIfThereIsAnyLocation() {
        if vegMeldingInfo.getLocationArray.isEmpty {
            noLocationFound(VC: self, okAction: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func goBack(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
