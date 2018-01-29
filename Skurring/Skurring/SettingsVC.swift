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


class SettingsVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var bckBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewForTableView: UIView!
    @IBOutlet weak var theTableView: UITableView!
    
    private var vegTrafikkInfo: [VegvesenCollectionObject] = []
    private var hasDownloadedVegInfo: Bool!
    private let manager = CLLocationManager()
    static var formatedVegTrafikkDesc: NSCache = NSCache<NSString, NSMutableAttributedString>()
    static var formatedVegTrafikkTitle: NSCache = NSCache<NSString, NSMutableAttributedString>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
        
        setupManager()
        setupTableView()
        
        hasDownloadedVegInfo = false
        self.loadingIndicator.color = UIColor.orange
        self.loadingIndicator.startAnimating()
        bckBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theIndex = self.vegTrafikkInfo[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "veg", for: indexPath) as? VegVesenInfoCell {
            if let formattedDesc = SettingsVC.formatedVegTrafikkDesc.object(forKey: theIndex.getDesc as NSString), let formattedTitle = SettingsVC.formatedVegTrafikkTitle.object(forKey: theIndex.getTitle as NSString) {
                cell.configureCell(vegTrafikkObject: theIndex, attributeColor: UIColor.orange, cachedDesc: formattedDesc, cachedTitle: formattedTitle)
            } else {
                cell.configureCell(vegTrafikkObject: theIndex, attributeColor: UIColor.orange)
            }
            return cell
        } else {
            return VegVesenInfoCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let senderObject = self.vegTrafikkInfo[indexPath.row]
        self.performSegue(withIdentifier: "vegTilKart", sender: senderObject)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vegTrafikkInfo.count
    }
    
    private func setupTableView() {
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.separatorStyle = .none
        self.theTableView.estimatedRowHeight = 100
        self.theTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.pausesLocationUpdatesAutomatically = true
    }

    private func updateButtonUI(btn: UIButton) {
        btn.layer.cornerRadius = 20
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            let location = locations[0]
           
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil {
                    if let placemark = placemarks?[0] {
                        if !self.hasDownloadedVegInfo {
                            if let fylke = placemark.administrativeArea {
                                let vegObj = XMLVegvesen.init(fylke: fylke)
                                vegObj.beginParsing(Completion: { (objectArray) in
                                    self.vegTrafikkInfo = objectArray
                                    DispatchQueue.main.sync {
                                        self.viewForTableView.isHidden = false
                                        self.hasDownloadedVegInfo = true
                                        self.loadingIndicator.hidesWhenStopped = true
                                        self.loadingIndicator.stopAnimating()
                                        
                                        UIView.animate(withDuration: 0.2, animations: {
                                            self.theTableView.tableHeaderView?.frame.size.height = 0
                                            self.theTableView.separatorStyle = .singleLine
                                        }, completion: { (true) in
                                            UIView.transition(with: self.theTableView, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                                                self.theTableView.reloadData()
                                            }, completion: nil)
                                        })
                                        
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func dismissVC(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vegTilKart" {
            if let destinationVC = segue.destination as? VegvesenKartVC {
                if let theSender = sender as? VegvesenCollectionObject {
                    destinationVC.vegMeldingInfo = theSender
                }
            }
        }
    }

    
}
