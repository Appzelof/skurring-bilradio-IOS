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
import GoogleMobileAds
import CoreLocation
import StoreKit
import Alamofire
import SwiftyJSON
import AudioToolbox


class PlayVC:  UIViewController, CLLocationManagerDelegate, GADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
   
    @IBOutlet var weatherImg: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet weak var theCollectionView: UICollectionView!
    var counterTime: Int = 0
    var counter: Int = 0
    var minInt: Int = 0
    var maxInt: Int = 4
    var weatherData = WeatherData()
    var channelInfo: SendObject!
    var CurrentPlayingTrack: CurrentPlayingTracks!
    var currentPlayingSong: String!
    var activeProduct: SKProduct?
    var weatherTimerHasBegan = false
    var timer: Timer?
    var placemark: CLPlacemark?
    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var bannerNativ: GADNativeExpressAdView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var theInfo: UILabel!
    @IBOutlet weak var TheLiveInfoSongName: UILabel!
    //KOBLE TIL DENNE FOR AT RESTEN AV LIVE INFO SKAL FUNKE.
    @IBOutlet weak var TheLiveInfoArtistName: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    
   
    let manager = CLLocationManager()
    let save = "save"
    @IBOutlet weak var speedButton: UIImageView!
    @IBOutlet weak var premiumBtn: UIButton!
    @IBOutlet weak var speedSwitch: UISwitch!
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    @IBOutlet var tapGest: UITapGestureRecognizer!
    @IBOutlet var restoreBtn: UIButton!
    
    private let DataServiceInstance = DS.dsInstance
    private var amountOfRadioStations: [MainScreenRadioObjects]!
    private let remoteCenter = MPRemoteCommandCenter.shared()
    private var thePrevCounter = 0
    private var scrolledToIndex: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrolledToIndex = false
        self.amountOfRadioStations = []
        self.getObjects()
        self.counter = self.getRadioRow()
        self.thePrevCounter = self.counter
        self.theCollectionView.delegate = self
        self.theCollectionView.dataSource = self
        self.theCollectionView.isPagingEnabled = true
        self.theCollectionView.backgroundColor = UIColor.clear
        
        self.theCollectionView.reloadData()
        theInfo.text = self.amountOfRadioStations[counter].radioInfo
        print("Number of radios: \(MainScreenRadioObjects.mainScreenRadioObjectsArray.count)")
        SKPaymentQueue.default().add(self)
        let productIdentifier: Set<String> = ["com.skurring.prem"]
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifier)
        productRequest.delegate = self
        productRequest.start()
        premiumBtn.layer.cornerRadius = 50
        premiumBtn.layer.masksToBounds = true
        kmLabel.isHidden = true
        banner.rootViewController = self
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-5770694165805669/4396564036"
        banner.load(GADRequest())
        
        
        

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
        speedSwitch.isHidden = true
        speedLabel.isHidden = true
        speedLabel.font = UIFont(name: "Digital-7Mono", size: 175)
        speedLabel.textAlignment = NSTextAlignment.center
        speedLabel.layer.shadowRadius = 8
        speedLabel.layer.shadowOpacity = 7
        speedLabel.layer.shadowOffset = CGSize.zero
        speedLabel.layer.masksToBounds = false
        speedButton.isHidden = true
        TheLiveInfoSongName.isHidden = true
        TheLiveInfoArtistName.isHidden = true
        tempLabel.isHidden = true
        cityLabel.isHidden = true
        weatherImg.isHidden = true
        SKPaymentQueue.default().add(self)
        
        CurrentPlayingTrack = CurrentPlayingTracks()
        updateTheLockscreen()
        //Registrerer metadata(artistNavn og sangNavn) når Player.radio spilles(play())
        
        NotificationCenter.default.addObserver(self, selector: #selector(NårManFårNyRadioInfo(notification:)), name: NSNotification.Name.MPMoviePlayerTimedMetadataUpdated, object: nil)
        
        //Hvis det er noe galt med radioKanalen så registrerer man det her
        
        NotificationCenter.default.addObserver(self, selector: #selector(NårEnErrorOppstårMenSpilling(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
        
        
        setUpPlayer()
        print(channelInfo.URL)
        
        playRadio(linken: self.amountOfRadioStations[counter].URL)
    
        
        UIApplication.shared.isIdleTimerDisabled = true
        
    
        //Loader IAP som bruker har kjøpt..
        if UserDefaults.standard.bool(forKey: save) {
            removeAds()
        }
        
    
        
        if let levels = UserDefaults.standard.value(forKey: "levels") {
            volumeSlider.value = levels as! Float
        }
        
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
    }
    
    private func updateCollectionViewPositionAndRadioName() {
        self.theInfo.text = getCurrentPlayingStationObject().radioInfo
        self.theCollectionView.scrollToItem(at: IndexPath.init(row: counter, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    //CollectionView methods
    
    private var theIndex: MainScreenRadioObjects!
    private var wantToDismiss = false
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        theIndex = amountOfRadioStations[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "radioPlayCell", for: indexPath) as? PlayRadioCell {
            cell.configureCell(radioObject: theIndex)
            return cell
        } else {
            return UICollectionViewCell()
        }
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
<<<<<<< HEAD
        
        vibrate();
        
        
    }
    
    public func vibrate(){
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator.init(style: .medium)
            generator.impactOccurred();
        } else {
            let vibrate = kSystemSoundID_Vibrate
            AudioServicesPlaySystemSound(vibrate)
        }
=======
>>>>>>> e68ce514d04c2c4e951b30883a313fd57d0856c7
    }
    
    private func getObjects() {
        for radioObject in MainScreenRadioObjects.mainScreenRadioObjectsArray {
            if radioObject.URL != "" {
                self.amountOfRadioStations.append(radioObject)
            }
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
            self.theInfo.text = indexObject.radioInfo
            
            self.counter = visibleIndexPath.row
            if self.counter != thePrevCounter {
                self.playRadio(linken: indexObject.URL)
                
                if #available(iOS 10.0, *) {
                    let generator = UIImpactFeedbackGenerator.init(style: .medium)
                    generator.impactOccurred();
                } else {
                    let vibrate = kSystemSoundID_Vibrate
                    AudioServicesPlaySystemSound(vibrate)
                }
            }
            
            thePrevCounter = self.counter
        }
    }
    
    
    
    
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        banner.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        banner.isHidden = true
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func NårManFårNyRadioInfo(notification: NSNotification) {
        
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
    
    
    private func getCurrentPlayingStationObject() -> MainScreenRadioObjects {
        return self.amountOfRadioStations[counter]
    }
 
    
    private func updateTheLockscreen() {
        if let currentPlayingSong = DS.dsInstance.currentPlayingSong["song"], let currentPlayingArtist = DS.dsInstance.currentPlayingSong["artist"] {
            updateLockScreen(Artist: currentPlayingArtist, songName: currentPlayingSong, channelName: getCurrentPlayingStationObject().radioInfo)
        } else if CurrentPlayingTrack.artistName != "" && CurrentPlayingTrack.songName != "" {
            updateLockScreen(Artist: CurrentPlayingTrack.artistName, songName: CurrentPlayingTrack.songName, channelName: getCurrentPlayingStationObject().radioInfo)
        } else {
            updateLockScreen(Artist: "", songName: "", channelName: getCurrentPlayingStationObject().radioInfo)
        }
    }
    
    func NårEnErrorOppstårMenSpilling(notification: NSNotification) {
        
        //Her kan du skrive inn hvilke beskjed du vil gi bruker hvis en error oppstår ved avspilling, også sette inn enten flere eller andre funksjoner
        
        HvisRadioenIkkeVilSpilleAv(VC: self, TittlenPåAlerten: "Noe gikk galt", BeksjedenPåAlerten: "Det skjedde noe galt med avspillingen av \(channelInfo.radioInfo)", PrøvIgjenKnappTittel: "Prøv igjen", ikkePrøvIgjenTittel: "Velg en annen kanal", prøvIgjenFunksjon: {
            //Man kan sette inn flere eller endre funksjoner her
            self.playRadio(linken: self.channelInfo.URL)
        }) {
            self.stopRadio()
            self.dismiss(animated: true, completion: nil)
        }
    }

    func playRadio(linken: String) {
        Player.radio.prepareToPlay()
        let url = URL.init(string: linken)
        
        Player.radio.contentURL = url
        
        Player.radio.play()
    }
    
    func stopRadio() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        Player.radio.pause()
    }
    
    private func stopAndDismissVC() {
        stopRadio()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeRadioPlay(_ sender: Any) {
        self.stopAndDismissVC()
    }
    

    
    
    @IBAction func longPressOnSpeedButton(_ sender: Any) {
        
        tempLabel.isHidden = false
        UserDefaults.standard.set(tempLabel.isEnabled, forKey: "isNotHidden")
        print("long press detected")
        
        
    }
    
    @IBAction func pressDisableButton(_sender: Any) {
       
        tempLabel.isHidden = true
        UserDefaults.standard.set(tempLabel.isHidden, forKey: "hidden")
        UserDefaults.standard.synchronize()
        print("tap detected")
    }
    
    
    @IBAction func volumeValue(_ sender: UISlider) {
        let volumeSlider = (MPVolumeView().subviews.filter { NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as! UISlider)
        volumeSlider.setValue(sender.value, animated: false)
        UserDefaults.standard.set(sender.value, forKey: "levels")
        UserDefaults.standard.synchronize()
    }
    
    private func nextStation() {
        self.counter += 1
        if self.counter > self.amountOfRadioStations.count - 1 {
            self.counter = 0
        }
        self.playRadio(linken: self.amountOfRadioStations[counter].URL)
    }
    
    private func previousStation() {
        self.counter -= 1
        if self.counter < 0 {
            self.counter = self.amountOfRadioStations.count - 1
        }
        self.playRadio(linken: self.amountOfRadioStations[self.counter].URL)
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        switch event!.subtype {
        case .remoteControlPlay:
            self.playRadio(linken: self.amountOfRadioStations[counter].URL)
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
                        self.updateFunction()
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
    
    func updateFunction() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            downloadWeatherData()
            UserDefaults.standard.synchronize()
        }
    }
    
    func updateCounter() {
        if counterTime == 0 {
            downloadWeatherData()
        } else if counterTime == 400 {
            counterTime = -1
        }
        counterTime += 1
        print("Counting... \(counterTime)")
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location manager failed")
    }
    
    @IBAction func restorePurchase(_ sender: Any) {
        
        if SKPaymentQueue.canMakePayments() == true {
        print("restored")
        SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            print("Could not restore!")
        }
    }
    
    
    @IBAction func buyPrem(_ sender: Any) {
        
        if SKPaymentQueue.canMakePayments() == true {
            
            print("Buy " + (activeProduct?.productIdentifier)!)
            let payment = SKPayment(product: activeProduct!)
            SKPaymentQueue.default().add(payment)
        } else {
            print("No product")
        }
    
    }
    
   
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("products")
        
        for product in response.products {
            
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price.floatValue)
            activeProduct = product
            
        }
        
    }
    
    
   
    
   func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
          
            
            switch (transaction.transactionState) {
            case .purchased, .restored:
                //Hva skjer når bruker kjøper:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Purchased")
                removeAds()
                UserDefaults.standard.set(true, forKey: save)
                UserDefaults.standard.synchronize()
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
                
                
                }
        }
    }
    
    

    
    func removeAds(){
        banner.isHidden = true
        banner.removeFromSuperview()
        restoreBtn.isHidden = true
        premiumBtn.isHidden = true
        speedButton.isHidden = false
        TheLiveInfoSongName.isHidden = false
        TheLiveInfoArtistName.isHidden = false
        speedSwitch.isHidden = false
        tempLabel.isHidden = false
        cityLabel.isHidden = false
        weatherImg.isHidden = false
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      
        return .lightContent
    }
    
    
    
}
