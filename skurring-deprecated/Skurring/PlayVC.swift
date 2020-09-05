//
//  PlayVC.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 16.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import CoreLocation
import StoreKit
import Alamofire

class PlayVC:  UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet var weatherImg: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBOutlet weak var bottomBackButton: UIButton!
    
    var counter: Int = 0
    var minInt: Int = 0
    var maxInt: Int = 4
    var weatherData = WeatherData()
    var channelInfo: SendObject!
    var CurrentPlayingTrack: CurrentPlayingTracks!
    var currentPlayingSong: String!
    var activeProduct: SKProduct?
    var weatherTimerHasBegan = false
    var placemark: CLPlacemark?
    
    @IBOutlet weak var TheLiveInfoSongName: UILabel!
    @IBOutlet weak var TheLiveInfoArtistName: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    
   
    let manager = CLLocationManager()
    let save = "save"
    @IBOutlet weak var speedButton: UIImageView!
    @IBOutlet weak var speedSwitch: UISwitch!
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet var tapGest: UITapGestureRecognizer!
    
    private let DataServiceInstance = DS.dsInstance
    var amountOfRadioStations: [Radiostations]!
    private let remoteCenter = MPRemoteCommandCenter.shared()
    private var thePrevCounter = 0
    private var scrolledToIndex: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrolledToIndex = false
        self.counter = self.getRadioRow()
        self.thePrevCounter = self.counter
        self.theCollectionView.delegate = self
        self.theCollectionView.dataSource = self
        self.theCollectionView.isPagingEnabled = true
        
        
        kmLabel.isHidden = true
        
        if let currentPlayingSong = DS.dsInstance.currentPlayingSong["song"], let currentPlayingArtist = DS.dsInstance.currentPlayingSong["artist"], let radioChannel = DS.dsInstance.currentPlayingSong["radioChannel"] {
            if radioChannel == channelInfo.radioInfo {
                self.TheLiveInfoSongName.text = currentPlayingSong
                self.TheLiveInfoArtistName.text = currentPlayingArtist
            } else {
                self.TheLiveInfoSongName.text = ""
                self.TheLiveInfoArtistName.text = channelInfo.radioInfo
            }
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        speedLabel.isHidden = true
        speedLabel.font = UIFont(name: "Digital-7Mono", size: 175)
        speedLabel.textAlignment = NSTextAlignment.center
        speedLabel.layer.shadowRadius = 8
        speedLabel.layer.shadowOpacity = 7
        speedLabel.layer.shadowOffset = CGSize.zero
        speedLabel.layer.masksToBounds = false
        bottomBackButton.imageView?.contentMode = .scaleAspectFit
        
        CurrentPlayingTrack = CurrentPlayingTracks()
        updateTheLockscreen()
        //Registrerer metadata(artistNavn og sangNavn) når Player.radio spilles(play())
        
        NotificationCenter.default.addObserver(self, selector: #selector(NårManFårNyRadioInfo(notification:)), name: NSNotification.Name.MPMoviePlayerTimedMetadataUpdated, object: nil)
        
        //Hvis det er noe galt med radioKanalen så registrerer man det her
        
        NotificationCenter.default.addObserver(self, selector: #selector(NårEnErrorOppstårMenSpilling(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
        
        
        setUpPlayer()
        print(channelInfo.URL)
        
        playRadio(linken: self.amountOfRadioStations[counter].radioStream)
    
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        if let on = UserDefaults.standard.value(forKey: "test"){
            speedSwitch.isOn = on as! Bool
        }
        
        if speedSwitch.isOn {
            self.theCollectionView.isHidden = true
            speedLabel.isHidden = false
            kmLabel.isHidden = false
            speedButton.image = UIImage(named: "green speed")
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        beginRecievingControllEvents(VC: self)
        showSwipeFunctionality()
    }
    
    /*
        Animerer cellene litt frem og tilbake for å vise brukeren at man kan scrolle.
        Kaller denne i viewDidAppear.
     */
    private func showSwipeFunctionality() {
        let currentOffset = self.theCollectionView.contentOffset
        var targetOffsetX: CGFloat!
        let offsetChange = self.theCollectionView.frame.width / 3
        if self.amountOfRadioStations.count == 1 {
            return
        } else if counter == 0 && self.amountOfRadioStations.count > 1 {
            targetOffsetX = currentOffset.x + offsetChange
        } else if counter == self.amountOfRadioStations.count - 1 {
            targetOffsetX = currentOffset.x - offsetChange
        } else {
            targetOffsetX = currentOffset.x + offsetChange
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.theCollectionView.contentOffset = CGPoint.init(x: targetOffsetX, y: 0)
        }) { (success) in
            self.theCollectionView.setContentOffset(currentOffset, animated: true)
        }
    }
    
    private func updateCollectionViewPositionAndRadioName() {
        self.theCollectionView.scrollToItem(at: IndexPath.init(row: counter, section: 0), at: UICollectionView.ScrollPosition.left, animated: false)
    }
    
    //CollectionView methods
    
    private var theIndex: Radiostations!
    private var wantToDismiss = false
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        theIndex = amountOfRadioStations[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "radioPlayCell", for: indexPath) as! PlayRadioCell
        cell.configureCell(radioObject: theIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.wantToDismiss = true
        self.stopAndDismissVC()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.amountOfRadioStations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !self.scrolledToIndex {
            self.updateCollectionViewPositionAndRadioName()
        }
        self.scrolledToIndex = true
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = UIScreen.main.bounds.width - 1.5
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    

    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !wantToDismiss {
            self.findVisibleCellAndPlay()
            self.wantToDismiss = false
        }
    }
    
    
    private func getRadioRow() -> Int {
        var selectedRow = 0
        
        for radioStations in self.amountOfRadioStations {
            if self.channelInfo.radioInfo == radioStations.radioInfo {
                break
            }
            selectedRow += 1
        }
        return selectedRow
    }
    
    
    private func findVisibleCellAndPlay() {
        var visibleRect = CGRect()
        visibleRect.origin = self.theCollectionView.contentOffset
        visibleRect.size = self.theCollectionView.bounds.size
        
        let visiblePoint = CGPoint.init(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath: IndexPath = self.theCollectionView.indexPathForItem(at: visiblePoint) {
            let indexObject = self.amountOfRadioStations[visibleIndexPath.row]
            
            self.counter = visibleIndexPath.row
            if self.counter != thePrevCounter {
                self.playRadio(linken: indexObject.radioStream)
                DS.dsInstance.checkDevice()
            }
            thePrevCounter = self.counter
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func NårManFårNyRadioInfo(notification: NSNotification) {
        
        if Player.radio.timedMetadata != nil && Player.radio.timedMetadata.count > 0 {
            let firstMeta: MPTimedMetadata = Player.radio.timedMetadata.first as! MPTimedMetadata
            let metaData = firstMeta.value as! String
            
            var stringParts: [String] = []
            
            if metaData.range(of: " - ") != nil {
                stringParts = metaData.components(separatedBy: " - ")
            } else if metaData.range(of: " med ") != nil {
                stringParts = metaData.components(separatedBy: " med ")
            } else {
                stringParts = metaData.components(separatedBy: "-")
            }
            
            
            if stringParts.count > 0 {
                CurrentPlayingTrack.artistName = stringParts[0]
                CurrentPlayingTrack.songName = stringParts[0]
            }
            
            if stringParts.count > 1 {
                CurrentPlayingTrack.songName = stringParts[1]
            }
            
            currentPlayingSong = CurrentPlayingTrack.songName
            
            self.TheLiveInfoSongName.text = CurrentPlayingTrack.songName
        
            if CurrentPlayingTrack.artistName == CurrentPlayingTrack.songName {
                self.TheLiveInfoArtistName.text = ""
            } else {
                self.TheLiveInfoArtistName.text = CurrentPlayingTrack.artistName
            }
            
            DS.dsInstance.currentPlayingSong["song"] = CurrentPlayingTrack.songName
            DS.dsInstance.currentPlayingSong["artist"] = CurrentPlayingTrack.artistName
            
            updateTheLockscreen()
        }
    }
    
    
    private func getCurrentPlayingStationObject() -> Radiostations {
        return self.amountOfRadioStations[counter]
    }
 
    
    private func updateTheLockscreen() {
        if let radioInfo = getCurrentPlayingStationObject().radioInfo {
            if let currentPlayingSong = DS.dsInstance.currentPlayingSong["song"], let currentPlayingArtist = DS.dsInstance.currentPlayingSong["artist"] {
                updateLockScreen(Artist: currentPlayingArtist, songName: currentPlayingSong, channelName: radioInfo)
            } else if CurrentPlayingTrack.artistName != "" && CurrentPlayingTrack.songName != "" {
                updateLockScreen(Artist: CurrentPlayingTrack.artistName, songName: CurrentPlayingTrack.songName, channelName: radioInfo)
            } else {
                updateLockScreen(Artist: "", songName: "", channelName: radioInfo)
            }
        }
    }
    
    @objc func NårEnErrorOppstårMenSpilling(notification: NSNotification) {
        
        //Her kan du skrive inn hvilke beskjed du vil gi bruker hvis en error oppstår ved avspilling, også sette inn enten flere eller andre funksjoner
        
        HvisRadioenIkkeVilSpilleAv(VC: self, TittlenPåAlerten: "Noe gikk galt", BeksjedenPåAlerten: "Det skjedde noe galt med avspillingen av \(channelInfo.radioInfo)", PrøvIgjenKnappTittel: "Prøv igjen", ikkePrøvIgjenTittel: "Velg en annen kanal", prøvIgjenFunksjon: {
            //Man kan sette inn flere eller endre funksjoner her
            self.playRadio(linken: self.channelInfo.URL)
        }) {
            self.stopRadio()
            self.dismiss(animated: true, completion: nil)
        }
    }

    func playRadio(linken: String?) {
        Player.radio.prepareToPlay()
        if let theLink = linken {
            let url = URL.init(string: theLink)
            Player.radio.contentURL = url
            Player.radio.play()
        }
    }
    
    func stopRadio() {
        Player.radio.pause()
    }
    
    private func stopAndDismissVC() {
        stopRadio()
        Player.radio.pause()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeRadioPlay(_ sender: Any) {
        self.stopAndDismissVC()
    }
    

    @IBAction func longPressOnSpeedButton(_ sender: Any) {
        tempLabel.isHidden = false
        UserDefaults.standard.set(tempLabel.isEnabled, forKey: "isNotHidden")
    }
    
    @IBAction func pressDisableButton(_sender: Any) {
        tempLabel.isHidden = true
        UserDefaults.standard.set(tempLabel.isHidden, forKey: "hidden")
        UserDefaults.standard.synchronize()
    }
    
    
    private func nextStation() {
        self.counter += 1
        if self.counter > self.amountOfRadioStations.count - 1 {
            self.counter = 0
        }
        self.playRadio(linken: self.amountOfRadioStations[counter].radioStream)
    }
    
    private func previousStation() {
        self.counter -= 1
        if self.counter < 0 {
            self.counter = self.amountOfRadioStations.count - 1
        }
        self.playRadio(linken: self.amountOfRadioStations[self.counter].radioStream)
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        switch event!.subtype {
        case .remoteControlPlay:
            self.playRadio(linken: self.amountOfRadioStations[counter].radioStream)
            break
        case .remoteControlPause:
            self.stopRadio()
            break
        case .remoteControlNextTrack:
            self.nextStation()
            break
        case .remoteControlPreviousTrack:
            self.previousStation()
            break
        default:
            break
        }
        self.updateCollectionViewPositionAndRadioName()
        thePrevCounter = self.counter
        
    }
    
    @IBAction func turnOn(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "test")
        UserDefaults.standard.synchronize()
        
        if  speedSwitch.isOn{
            self.theCollectionView.isHidden = true
            speedLabel.isHidden = false
            kmLabel.isHidden = false
            speedButton.image = UIImage(named: "green speed")
        }
        
       else if !speedSwitch.isOn {
            self.theCollectionView.isHidden = false
            kmLabel.isHidden = true
            speedLabel.isHidden = true
            speedButton.image = UIImage(named: "speed")
        }
        
        UserDefaults.standard.set(sender.isOn, forKey: "test")
        UserDefaults.standard.synchronize()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locations = locations[locations.count - 1]
        let total = locations.speed * 3.6
        let one = Int(total)
       
        if !self.weatherTimerHasBegan {
            CLGeocoder().reverseGeocodeLocation(locations) { (placemarks, error) in
                if error == nil {
                    if let placemark = placemarks?[0] {
                        self.placemark = placemark
                      //  self.updateFunction()
                        self.downloadWeatherData()
                    }
                } else {
                    print(error!)
                }
            }
        }
        
    
        if one >= 100 {
            speedLabel.textColor = UIColor.yellow
            speedLabel.layer.shadowColor = speedLabel.textColor.cgColor
        }
        
         if one >= 120 {
            speedLabel.textColor = UIColor.red
            speedLabel.layer.shadowColor = speedLabel.textColor.cgColor
        }
        
        if one < 100 {
            speedLabel.textColor = UIColor.green
            speedLabel.layer.shadowColor = speedLabel.textColor.cgColor
        }
        
        if one < 0 {
            speedLabel.text = "0"
        } else {
            speedLabel.text = String(one)
        }

    }
    
    func downloadWeatherData() {
        if let thePlacemark = self.placemark {
            if thePlacemark.locality != nil {
                cityLabel.text = thePlacemark.locality
            } else {
                cityLabel.text = "Kan ikke laste lokasjon"
            }
            let weatherObject = XMLWeather.init(postalCode: thePlacemark.postalCode, countryCode: thePlacemark.isoCountryCode)
            weatherObject.beginParsing(Completed: { (theObject, wentAsync) in
                if !wentAsync {
                    self.tempLabel.text = ""
                    self.weatherImg.image = UIImage()
                } else {
                    DispatchQueue.main.sync {
                        if theObject.getImageName != "" && theObject.getTemperature != "" {
                            if let theTemp = Int(theObject.getTemperature) {
                                let weatherImageFilter = WeatherFilter()
                                self.weatherImg.image = UIImage(named: weatherImageFilter.formatWeatherIcon(weatherIconName: theObject.getImageName))
                                
                                if theTemp <= 0 {
                                    self.tempLabel.textColor = UIColor.blue
                                } else {
                                    self.tempLabel.textColor = UIColor.red
                                }
                                
                                self.tempLabel.text = "\(theObject.getTemperature)ºC"
                            } else {
                                self.tempLabel.text = ""
                                self.weatherImg.image = UIImage()
                            }
                        } else {
                            self.tempLabel.text = ""
                            self.weatherImg.image = UIImage()
                        }
                        
                        self.weatherTimerHasBegan = true
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location manager failed")
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func bottomBackButtonAction(_ sender: UIButton!) {
        self.stopAndDismissVC()
    }
    
    
    
}
