//
//  ViewController.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 11.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import MediaPlayer
import AudioToolbox
import FBSDKCoreKit
import StoreKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ParkingOrEmergencyWasPressed, StationWasLongOrJustPressed {
    
    
    @IBOutlet weak var channelCollectionView: UICollectionView!
    
    var ObjektSenderen: SendObject!
    
    private var coreDataManager: CoreDataManager!
    private var allStations: [Radiostations]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreDataManager = CoreDataManager()
        allStations = coreDataManager.getAllStations()
        self.channelCollectionView.delegate = self
        self.channelCollectionView.dataSource = self
        self.channelCollectionView.isScrollEnabled = false
        setUpBackgroundMode()
        radioInformation.parse()
        
        
        if allStations.isEmpty {
            self.allStations = lagTommeObjekterTilMainScreenRadioObjectsHvisArrayenErTom(context: self.coreDataManager.context)
        } else {
            self.allStations = self.coreDataManager.getAllStations()
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.allStations = self.coreDataManager.getAllStations()
        self.channelCollectionView.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var channelCellIndexInfo: Radiostations!
        if indexPath.row < 6 {
            channelCellIndexInfo = self.allStations[indexPath.row] //May need to sort this?
        }
        
        if indexPath.row == 6 {
            let trafficToolCell = collectionView.dequeueReusableCell(withReuseIdentifier: "toolCell", for: indexPath) as! DrivingToolkitCell
            trafficToolCell.configureCell(protocolListener: self)
            return trafficToolCell
        } else {
            let channelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCell", for: indexPath) as! MainPageChannelsCell
            channelCell.configureCell(station: channelCellIndexInfo, delegateListener: self)
            return channelCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6 {
            return CGSize.init(width: self.channelCollectionView.bounds.width, height: (channelCollectionView.bounds.height * 0.22) - 6)
        } else {
            return CGSize.init(width: (self.channelCollectionView.bounds.width / 2) - 4, height: (channelCollectionView.bounds.height * 0.165) - 6)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /*
        Driving toolkit cell's custom protocol methods.
     */
    
    func parkingWasPressed() {
        self.performSegue(withIdentifier: "toHjelpVC", sender: nil)
    }
    
    func emergencyWasPressed() {
        let options = CallOptions()
        self.present(callOptions(nødhjelpAction: {
            self.performSegue(withIdentifier: "toHjelpVC", sender: options.getNødHjelp())
        }, veihjelpActon: {
            self.performSegue(withIdentifier: "toHjelpVC", sender: options.getVeiHelp())
        }), animated: true, completion: nil)
    }
    
    func trafficMessages() {
        performSegue(withIdentifier: "Settings", sender: nil)
    }
    
    /*
        Channel station custom protocol methods.
     */
    
    func longPressed(spot: Int) {
      //  DS.dsInstance.checkDevice()
        print("Spot: \(spot)")
        self.performSegue(withIdentifier: "RadioList", sender: spot)
    }
    
    func pressed(station: Radiostations) {
        if station.radioStream != "" {
            if let imageData = station.radioImage, let radioStream = station.radioStream, let radioInfo = station.radioInfo {
                let theObjectSender = SendObject.init(image: imageData as NSData, URL: radioStream, radioInfo: radioInfo, radioNumber: Int(station.radioSpot))
                self.performSegue(withIdentifier: "PlayVC", sender: theObjectSender)
            }
            
        }
    }
    
    func applicationDidBecomeActvice(application: UIApplication){
        FBSDKAppEvents.activateApp()
    }
    
    func rating(){
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayVC" {
            if let detail = segue.destination as? PlayVC{
                if let Sender = sender as? SendObject{
                    detail.channelInfo = Sender
                    //Man vet ikke om alle knappene har en kanal, derfor filtreres de som ikke har kanal ut.
                    //De som har kanal bli da lagret og "sendt" til PlayVC
                    detail.amountOfRadioStations = self.allStations.filter({ (obj) -> Bool in
                        return obj.radioStream != ""
                    })
                    //Siden kanal-arrayen nå kan ha en annen størrelse, så
                    var counter = 0
                    for station in detail.amountOfRadioStations {
                        if let radioInfo = station.radioInfo {
                            if radioInfo == Sender.radioInfo {
                                detail.counter = counter
                                break
                            }
                        }
                        counter += 1
                    }
                }
            }
        } else if segue.identifier == "toHjelpVC" {
            if let destinationVC = segue.destination as? HjelpVC {
                if let Sender = sender as? [Options] {
                    destinationVC.options = Sender
                }
            }
        } else if segue.identifier == "RadioList" {
            if let destinationVC = segue.destination as? RadioListVC {
                if let radioSpot = sender as? Int {
                    destinationVC.radioSpot = radioSpot
                    destinationVC.coreDataManager = self.coreDataManager
                }
            }
        }
    }
  
}

extension String {
    func formatDescription() -> String {
        let filter = self.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")
        return filter
    }
}









