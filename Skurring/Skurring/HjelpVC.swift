//
//  HjelpVC.swift
//  Skurring
//
//  Created by Marius Fagerhol on 21/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
import MapKit

class HjelpVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var placeInfoView: BorderedView!
    @IBOutlet weak var placeInfo: UILabel!
    @IBOutlet weak var parkView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var parkBtn: ShadowCircularButton!
    @IBOutlet weak var drawLineToCarBtn: ShadowCircularButton!
    @IBOutlet weak var stackViewWidth: UIStackView!
    @IBOutlet weak var carStackView: UIStackView!
    @IBOutlet weak var carInfoLabel: UILabel!
    @IBOutlet weak var carInfoView: BorderedView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    var options: [Options]?
    private let manager = CLLocationManager()
    private var hasUpdatedMap = false
    private var incrementLocation = ""
    
    private let annotation = MKPointAnnotation()
    private let user = UserDefaults()
    private var polyLineOverlay: MKRoute = MKRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.alpha = 0
        parkView.alpha = 0
        self.placeInfoView.alpha = 0
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        mapView.delegate = self
        manager.delegate = self
        
        dismissBtn.imageView?.contentMode = .scaleAspectFit
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.pausesLocationUpdatesAutomatically = true
        mapView.showsUserLocation = true
        mapView.userLocation.title = "Min plassering"
        updateLocationViewLayout()
    }
    
    
 
    
    func updateLocationViewLayout() {
        
        if options != nil {
            hideParkingUI()
            self.containerHeight.constant = 200
            animate(whatToAnimate: {
                self.theTableView.alpha = 1
            })
        } else {
            if let data = user.dictionary(forKey: "locationData") {
                if let lat = data["lat"] as? CLLocationDegrees, let long = data["long"] as? CLLocationDegrees {
                    let location = CLLocationCoordinate2DMake(lat, long)
                    annotation.coordinate = location
                    annotation.title = "Her har du parkert"
                    mapView.addAnnotation(annotation)
                    self.parkBtn.setTitle("", for: UIControlState.normal)
                    
                    if let endParkingImage = UIImage(named: "no-parking-sign") {
                        self.parkBtn.setImage(endParkingImage, for: .normal)
                    }
                    let pureCarLocaion = CLLocation.init(latitude: lat, longitude: long)
                    self.addCarGestureIfNotExsist()
                    
                    self.geoCode(location: pureCarLocaion, whichLabel: self.carInfoLabel, whichView: self.carInfoView)
                    self.stackViewWidth.spacing = UIScreen.main.bounds.width / 8
                    self.carStackView.spacing = UIScreen.main.bounds.width / 8
                }
            } else {
                hideParkingUI()
            }
        
            
            self.theTableView.isHidden = true
            self.containerHeight.constant = 150
            animate(whatToAnimate: {
                self.parkView.alpha = 1
            })
        }
        self.placeInfoView.isUserInteractionEnabled = true
        self.placeInfoView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.scrollToUserLocation)))
    }
    
   private func addCarGestureIfNotExsist() {
    self.carInfoView.isUserInteractionEnabled = true
    if self.carInfoView.gestureRecognizers != nil {
        self.carInfoView.gestureRecognizers!.removeAll()
    }
    self.carInfoView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.scrollToCarLocation)))
   }
    
   private func hideParkingUI() {
        self.carInfoView.isHidden = true
        self.drawLineToCarBtn.isHidden = true
    }
    
   private func animate(whatToAnimate: @escaping () -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            whatToAnimate()
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer.init(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let myAnnotation = view.annotation {
            if !myAnnotation.isKind(of: MKUserLocation.self) {
                presentTransportToCarOptions()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !annotation.isKind(of: MKUserLocation.self)  {
            let annotationReuseID = "pinID"
            var annotationView: MKAnnotationView?
            
            if let dequedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseID) {
                annotationView = dequedAnnotationView
                annotationView?.annotation = annotation
            } else {
                annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: annotationReuseID)
            }
            
            if let annotationView = annotationView {
                annotationView.canShowCallout = true
                annotationView.image = UIImage(named: "placeholder")
            }
            return annotationView
        } else {
            return nil
        }
    }
    
    private func geoCode(location: CLLocation, whichLabel: UILabel, whichView: UIView) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
            self.incrementLocation = ""
            if error == nil {
                if let placemark = placemark {
                    if !placemark.isEmpty {
                        if let thoroughfare = placemark[0].thoroughfare {
                            self.incrementLocation += "\(thoroughfare) \n"
                            if let subThoroughfare = placemark[0].subThoroughfare {
                                self.incrementLocation = "\(thoroughfare) \(subThoroughfare) \n"
                            }
                        }
                        
                        if let subLocality = placemark[0].subLocality  {
                            self.incrementLocation += "\(subLocality) \n"
                        }
                        
                        if let locality = placemark[0].locality, let postalCode = placemark[0].postalCode  {
                            self.incrementLocation += "\(postalCode) \(locality) \n"
                        }
                        whichLabel.text = self.incrementLocation
                        if self.incrementLocation != "" {
                            UIView.animate(withDuration: 0.2, animations: {
                                whichView.alpha = 1
                            })
                        }
                    }
                }
            }
        })
    }
    
    @objc private func scrollToUserLocation() {
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let myLocation = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc private func scrollToCarLocation() {
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let carLocation = CLLocationCoordinate2DMake(self.annotation.coordinate.latitude, self.annotation.coordinate.longitude)
        let region = MKCoordinateRegionMake(carLocation, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            let location = locations[0]
            let span = MKCoordinateSpanMake(0.002, 0.002)
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region = MKCoordinateRegionMake(myLocation, span)
            if !hasUpdatedMap {
                mapView.setRegion(region, animated: true)
                hasUpdatedMap = true
            }
            self.geoCode(location: location, whichLabel: self.placeInfo, whichView: self.placeInfoView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let options = options {
            if let theUrl = URL.init(string: options[indexPath.row].number) {
                 UIApplication.shared.openURL(theUrl)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let options = options {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell", for: indexPath) as? EmergencyCell {
                cell.configureCell(info: options[indexPath.row])
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let options = options {
            return options.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.theTableView.frame.height / 3
    }
    
    private func removeUserParkingLocationAndReset() {
        user.removeObject(forKey: "locationData")
        animate(whatToAnimate: {
            self.mapView.removeAnnotation(self.annotation)
            self.drawLineToCarBtn.alpha = 0
            self.drawLineToCarBtn.isHidden = true
            self.carInfoView.alpha = 0
            self.carInfoView.isHidden = true
            self.mapView.remove(self.polyLineOverlay.polyline)
            self.parkBtn.setTitle("P", for: UIControlState.normal)
            self.parkBtn.setImage(UIImage(), for: .normal)
        })
    }
    
    private func addUserParkingLocationAndShowParking() {
        let location = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude)
        annotation.coordinate = location
        annotation.title = "Her står bilen"
        let longitude = location.longitude
        let latitude = location.latitude
        let userLocation: Dictionary<String, CLLocationDegrees> = ["lat": latitude, "long": longitude]
        mapView.addAnnotation(annotation)
        user.set(userLocation, forKey: "locationData")
        user.synchronize()
        let carLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        animate(whatToAnimate: {
            self.carInfoView.alpha = 1
            self.carInfoView.isHidden = false
            self.drawLineToCarBtn.alpha = 1
            self.drawLineToCarBtn.isHidden = false
            self.parkBtn.setTitle("", for: UIControlState.normal)
            if let endParkingImage = UIImage(named: "no-parking-sign") {
                self.parkBtn.setImage(endParkingImage, for: .normal)
            }
            self.addCarGestureIfNotExsist()
        })
        self.geoCode(location: carLocation, whichLabel: self.carInfoLabel, whichView: self.carInfoView)
    }
    
    @IBAction func park(_ sender: UIButton!) {
        if self.parkBtn.currentTitle == "" {
            removeUserParkingLocationAndReset()
        } else {
            addUserParkingLocationAndShowParking()
        }
    }
    
    private func drawLineFromCarToUser(transportType: MKDirectionsTransportType) {
        if self.mapView.overlays.count > 0 {
            self.mapView.remove(self.polyLineOverlay.polyline)
        }
        
        let sourceLocation = CLLocationCoordinate2D.init(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        let destinationLocation = CLLocationCoordinate2D.init(latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude)
        
        let sourcePlacemark = MKPlacemark.init(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark.init(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem.init(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem.init(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = transportType
        
        let directions = MKDirections.init(request: directionRequest)
        directions.calculate { (response, error) in
            if error == nil {
                if let theResponse = response {
                    if !theResponse.routes.isEmpty {
                        let route = theResponse.routes[0]
                        self.polyLineOverlay = route
                        self.mapView.add(self.polyLineOverlay.polyline, level: MKOverlayLevel.aboveRoads)
                    }
                }
            } else {
                print("Error occured: \(error.debugDescription)")
            }
        }
    }
    
    private func presentTransportToCarOptions() {
        self.present(getToCarOptions(walk: {
            self.drawLineFromCarToUser(transportType: MKDirectionsTransportType.walking)
        }, drive: {
            self.drawLineFromCarToUser(transportType: MKDirectionsTransportType.automobile)
        }), animated: true, completion: nil)
    }
    
    @IBAction func drawLineToParkedCarTapped(_ sender: UIButton!) {
        self.presentTransportToCarOptions()
    }
    
    @IBAction func dismissVC(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
