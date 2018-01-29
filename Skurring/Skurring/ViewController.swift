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
import TransitionTreasury


var actionInt = 0

class ViewController: UIViewController {
    
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var Clock: UILabel!
    @IBOutlet weak var hold: UILabel!
    weak var modelDelegate: ModalTransitionDelegate?
    var transition: TRViewControllerTransitionDelegate?
    private var rssItems: [RSSItem]?
    
    
    //Dette bildet er det første bildet altså bildet på knappen nummer 0
    @IBOutlet weak var image1: UIImageView!
    
    //Dette bildet er det andre bildet altså bildet på knappen nummer 1
    @IBOutlet weak var image2: UIImageView!
    
    //Dette bildet er det tredje bildet altså bildet på knappen nummer 2
    @IBOutlet weak var image3: UIImageView!
    
    //Dette bildet er det fjerde bildet altså bildet på knappen nummer 3
    @IBOutlet weak var image4: UIImageView!
    
    //Dette bildet er det femte bildet, altså bildet på knappen nummer 4
    @IBOutlet weak var image5: UIImageView!
    
    //Dette bildet er det sjette bildet, altså bildet på knappen nummer 5
    @IBOutlet weak var image6: UIImageView!
    
    @IBOutlet weak var HoldToStorePresentNr0: UILabel!
    
    //jeg har ikke koblet disse til
    @IBOutlet weak var HoldToStorePresentNr1: UILabel!
    
    @IBOutlet weak var HoldToStorePresentNr2: UILabel!
    
    @IBOutlet weak var HoldToStorePresentNr3: UILabel!
    
    @IBOutlet weak var HoldToStorePresentNr4: UILabel!
    
    @IBOutlet weak var HoldToStorePresentNr5: UILabel!
    
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var parkBtn: UIButton!
    
    
    //Setter teller variablen global sånn at man kan bruke den samme instansen overalt i denne classen. Feks hvis du etterhvert vil stoppe tiden, eller gjøre hva du vil så kan du bruke timer variabelen for det.
    var timer: Timerbrain!
    
    //Setter date her sånn at man ikke lager en ny instanse for hver gang tiden teller
    var date: Date!
    
    var ObjektSenderen: SendObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpBackgroundMode()
        radioInformation.parse()
        
        loadData()
        
        
        if MainScreenRadioObjects.mainScreenRadioObjectsArray.isEmpty {
            MainScreenRadioObjects.mainScreenRadioObjectsArray = lagTommeObjekterTilMainScreenRadioObjectsHvisArrayenErTom()
            
        } else {
            
        }
        
        timer = Timerbrain()
        
        //Setter funksjonene her for at appen skal vite at den skal begynne å telle nå
        
        timer.startTimer(VC: self, selector: #selector(ViewController.updateTime))
        
        phoneView.isUserInteractionEnabled = true
        phoneView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(phoneImageTapped)))
        phoneView.layer.cornerRadius = phoneView.bounds.height / 2
        parkBtn.layer.cornerRadius = 5
        parkBtn.clipsToBounds = true
        parkBtn.layer.cornerRadius = parkBtn.bounds.height / 2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //Det er her UI-en skal oppdaters siden det er denne funksjonen som blir brukt automatisk rett etter man dismisser Vc-en i didSelect funksjonen i RadioListVC.
        
        
        //Man burde egentlig ha dette i en funksjon i en annen fil, men for å gjøre det enklere å forstå så bare skriver jeg det her. Det finnes også sikkert mange andre gode løsninger, men denne er det letteste å forstå.
        //I denne If-statementen så sjekker jeg om bildet er "" eller har en verdi, hvis den ikke har så har de ikke brukt appen før, eller så skal den ha. Så hold to store skal bare vises en gang? Har beregnet at kundene vet at de skal holde for å velge ny etter første gang de har gjort det.
        
        
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[0].image != "" {
            self.HoldToStorePresentNr0.isHidden = true
        } else {
            self.HoldToStorePresentNr0.isHidden = false
        }
        
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[1].image != "" {
            self.HoldToStorePresentNr1.isHidden = true
        } else {
            self.HoldToStorePresentNr1.isHidden = false
        }
        
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[2].image != "" {
            self.HoldToStorePresentNr2.isHidden = true
        } else {
            self.HoldToStorePresentNr2.isHidden = false
        }
        
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[3].image != "" {
            self.HoldToStorePresentNr3.isHidden = true
        } else {
            self.HoldToStorePresentNr3.isHidden = false
        }
        
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[4].image != "" {
            self.HoldToStorePresentNr4.isHidden = true
        } else {
            self.HoldToStorePresentNr4.isHidden = false
        }
        
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[5].image != "" {
            self.HoldToStorePresentNr5.isHidden = true
        } else {
            self.HoldToStorePresentNr5.isHidden = false
        }
        
        //Her så er det bare å fortsette med If-statement. Labelsene står i veien for knappene etter man ha valgt kanal, så derfor så bare gjemmer vi dem når de har valgt kanal.
        
        
        //her så oppdaterer jeg UI-en
        self.image1.image = UIImage(named: MainScreenRadioObjects.mainScreenRadioObjectsArray[0].image)
        self.image2.image = UIImage(named: MainScreenRadioObjects.mainScreenRadioObjectsArray[1].image)
        self.image3.image = UIImage(named: MainScreenRadioObjects.mainScreenRadioObjectsArray[2].image)
        self.image4.image = UIImage(named: MainScreenRadioObjects.mainScreenRadioObjectsArray[3].image)
        self.image5.image = UIImage(named: MainScreenRadioObjects.mainScreenRadioObjectsArray[4].image)
        self.image6.image = UIImage(named: MainScreenRadioObjects.mainScreenRadioObjectsArray[5].image)

        
    }
    
    
    //Single Tap method
    //Denne knappen er kun for den første knappen
    //Jo flere knapper du lager så øker du 0-taller med 1 og du starter fra 0 som du ser i @IBAction under 
    //Altså 0-taller er: MainScreenRadioObjects.mainScreenRadioObjectsArray[0], og denne skal økes med 1 for hver knapp du legger til.
    @IBAction func singleTap(_ sender: UIButton) {
        print("Tap happend")
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[0].image != "" {
            //ObjektSenderen er objektet som blir laget for hver knapp man klikker på, så det er bare en ryddigere metode enn den forrige, men fungerer på akkurat samme måte. Så neste er å fortsette sånn som står her på de andre knappene også så ser du magi xD
            ObjektSenderen = SendObject.init(image: MainScreenRadioObjects.mainScreenRadioObjectsArray[0].image, URL: MainScreenRadioObjects.mainScreenRadioObjectsArray[0].URL, radioInfo: MainScreenRadioObjects.mainScreenRadioObjectsArray[0].radioInfo, radioNumber: 0)
            performSegue(withIdentifier: "PlayVC", sender: ObjektSenderen)
            

        }
        
        
    }
  
    //Brukte single tap gesture her siden jeg måtte teste om det var noe med knappen eller ikke, men fant ut det var labels som stod i veien xD Så det er bare å disconnect Single Tap Gesture fra knappen også legger du til en @IBAction som du gjorde ved singeTap, også bare skriver du det samme som står her.
    @IBAction func singlTapBtnNr2(_ sender: UIButton!) {
        
        print("Tap happend nr2")
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[1].image != "" {
            
            ObjektSenderen = SendObject.init(image: MainScreenRadioObjects.mainScreenRadioObjectsArray[1].image, URL: MainScreenRadioObjects.mainScreenRadioObjectsArray[1].URL, radioInfo: MainScreenRadioObjects.mainScreenRadioObjectsArray[1].radioInfo, radioNumber: 1)
            performSegue(withIdentifier: "PlayVC", sender: ObjektSenderen)
            
        }
        
    }
    
    @IBAction func singleTapbtnNr3(_ sender: UIButton!) {
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[2].image != "" {
            
            ObjektSenderen = SendObject.init(image: MainScreenRadioObjects.mainScreenRadioObjectsArray[2].image, URL: MainScreenRadioObjects.mainScreenRadioObjectsArray[2].URL, radioInfo: MainScreenRadioObjects.mainScreenRadioObjectsArray[2].radioInfo, radioNumber: 2)
            performSegue(withIdentifier: "PlayVC", sender: ObjektSenderen)
            
        }
    }
    
    @IBAction func singleTapbtnNr4(_ sender: UIButton!) {
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[3].image != "" {
            
            ObjektSenderen = SendObject.init(image: MainScreenRadioObjects.mainScreenRadioObjectsArray[3].image, URL: MainScreenRadioObjects.mainScreenRadioObjectsArray[3].URL, radioInfo: MainScreenRadioObjects.mainScreenRadioObjectsArray[3].radioInfo, radioNumber: 3)
            performSegue(withIdentifier: "PlayVC", sender: ObjektSenderen)
            
        }
    }
    
    @IBAction func singleTapbtnNr5(_ sender: UIButton!) {
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[4].image != "" {
            
            ObjektSenderen = SendObject.init(image: MainScreenRadioObjects.mainScreenRadioObjectsArray[4].image, URL: MainScreenRadioObjects.mainScreenRadioObjectsArray[4].URL, radioInfo: MainScreenRadioObjects.mainScreenRadioObjectsArray[4].radioInfo, radioNumber: 4)
            performSegue(withIdentifier: "PlayVC", sender: ObjektSenderen)
            
        }
    }
    
    @IBAction func singleTapbtnNr6(_ sender: UIButton!) {
        if MainScreenRadioObjects.mainScreenRadioObjectsArray[5].image != "" {
            
            ObjektSenderen = SendObject.init(image: MainScreenRadioObjects.mainScreenRadioObjectsArray[5].image, URL: MainScreenRadioObjects.mainScreenRadioObjectsArray[5].URL, radioInfo: MainScreenRadioObjects.mainScreenRadioObjectsArray[5].radioInfo, radioNumber: 5)
            performSegue(withIdentifier: "PlayVC", sender: ObjektSenderen)
            
        }
    }
    
    
   
    //Long press method. (Makes the device vibrate)
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        actionInt = 0
        
        if sender.state == UIGestureRecognizerState.began {
            print("Long Press")
            self.performSegue(withIdentifier: "RadioList", sender: nil)
            vibrateWhenClicked()
        }
        
        
    }
    
    @IBAction func longPressForBtnNr2(_ sender: UILongPressGestureRecognizer) {
        //Her ser du jeg plusser på 1 på actionInt fra 0 som er over, dette gjør jeg for å sjekke i hvilken rad i arrayen av objekter jeg skal ta fra. Også på neste knapp så setter du actionInt til 2, og det må gjøres før du skriver noe annet i knapp @IBAction.
        actionInt = 1
        
        if sender.state == UIGestureRecognizerState.began {
            print("Long Press")
            performSegue(withIdentifier: "RadioList", sender: nil)
            vibrateWhenClicked()
        }
    }
    
    @IBAction func longPressForbtn3(_ sender: UILongPressGestureRecognizer) {
        
        actionInt = 2
        
        if sender.state == UIGestureRecognizerState.began {
            print("Long Press")
            performSegue(withIdentifier: "RadioList", sender: nil)
            vibrateWhenClicked()
        }
        
    }
    
    
    @IBAction func longPressForBtn4(_ sender: UILongPressGestureRecognizer) {
        
        actionInt = 3
        
        if sender.state == UIGestureRecognizerState.began {
            print("Long Press")
            performSegue(withIdentifier: "RadioList", sender: nil)
            vibrateWhenClicked()
        }
        
    }
    
    
    @IBAction func longPressForBtn5(_ sender: UILongPressGestureRecognizer) {
        
        actionInt = 4
        
        if sender.state == UIGestureRecognizerState.began {
            print("Long Press")
            performSegue(withIdentifier: "RadioList", sender: nil)
            vibrateWhenClicked()
        }
        
    }
    
    
    @IBAction func longPressForBtn6(_ sender: UILongPressGestureRecognizer) {
        
        actionInt = 5
        
        if sender.state == UIGestureRecognizerState.began {
            print("Long Press")
            performSegue(withIdentifier: "RadioList", sender: nil)
            vibrateWhenClicked()
        }
        
    }
    
    
    
    //Makes the device vibrate.
    func vibrateWhenClicked(){
        
        let vibrate = kSystemSoundID_Vibrate
        AudioServicesPlaySystemSound(vibrate)
        
    }
    
    
    
    //Real time clock.
    
    func updateTime(){
        date = Date()
        Clock.text = DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)

    }
    
    
  
    
    
    func applicationDidBecomeActvice(application: UIApplication){
        FBSDKAppEvents.activateApp()
    }
    
    @IBAction func toHelpAndSupport() {
        performSegue(withIdentifier: "Settings", sender: nil)
    }
    
    
    func rating(){
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    }


    func phoneImageTapped() {
        let options = CallOptions()
        self.present(callOptions(nødhjelpAction: {
            self.performSegue(withIdentifier: "toHjelpVC", sender: options.getNødHjelp())
        }, veihjelpActon: {
            self.performSegue(withIdentifier: "toHjelpVC", sender: options.getVeiHelp())
        }), animated: true, completion: nil)
    }
    
    @IBAction func parkTapped(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "toHjelpVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayVC" {
            if let detail = segue.destination as? PlayVC{
                if let Sender = sender as? SendObject{
                    detail.channelInfo = Sender
                }
            }
        } else if segue.identifier == "toHjelpVC" {
            if let destinationVC = segue.destination as? HjelpVC {
                if let Sender = sender as? [Options] {
                    destinationVC.options = Sender
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









