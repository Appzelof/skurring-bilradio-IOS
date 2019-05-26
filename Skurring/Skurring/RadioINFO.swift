//
//  RadioINFO.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 17.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.


import Foundation

class RadioPlayer {

    private var _imgPNG: String!
    private var _radioINFO: String!
    private var _radioStream: String!
    private var _radioSearchName: String!
    
    var imgPNG: String{
        if _imgPNG != nil{
        return _imgPNG
        } else {
            return ""
        }
    }
    
    var radioSearchName: String {
        return _radioSearchName
    }
    
    var radioINFO: String {
        return _radioINFO
    }
    
    var radioStream: String{
        return _radioStream
    }
    
    /* Radiostations from firebase */
    
    var parsedRadioStations: [RadioPlayer]!
    
    /* Getting data from firebase */
    /*
    init?(dataFromFirebase: Any) {
        parsedRadioStations = []
        guard let firebaseSnapshots = dataFromFirebase as? [DataSnapshot] else {
            return nil
        }
        
        for stationsSnapshot in firebaseSnapshots {
            if let station = stationsSnapshot.value as? [String: String] {
                if let radioStation = RadioPlayer.init(imageUrl: station["imageUrl"], radioName: station["name"], radioStream: station["streamUrl"], radioSearchName: station["search"]) {
                    parsedRadioStations.append(radioStation)
                }
            }
        }
 
    }
 */
    /* Parsing each station from firebase */
    
    private init?(imageUrl: String?, radioName: String?, radioStream: String?, radioSearchName: String?) {
        guard let theImageUrl = imageUrl, let theRadioName = radioName, let theRadioStream = radioStream, let theRadioSearchName = radioSearchName else {
            return nil
        }
        self._imgPNG = theImageUrl
        self._radioINFO = theRadioName
        self._radioStream = theRadioStream
        self._radioSearchName = theRadioSearchName
    }

    /* Useless */
    init(TheDict: Dictionary<String, String>) {
        self._imgPNG = TheDict["imageURL"]
        self._radioINFO = TheDict["name"]
        self._radioStream = TheDict["streamURL"]
        self._radioSearchName = TheDict["search"]
    }
    
    

}


struct radioInformation{
    
    var theDesc = ""
    var theName = ""
    var theStreamUrl = ""
    var theImageUrl = ""
    static var theStationObjects: [RadioPlayer] = []
    static var theFilteredStationsObjects: [RadioPlayer] = []
    
    static func parse(){
        for data in stations {
            let Object = RadioPlayer.init(TheDict: data)
            radioInformation.theStationObjects.append(Object)
        }
        
    }
    
    static let stations: [Dictionary<String, String>] = [
        
       
        [
            "search": "nrk mp3",
            "desc": "Hits/Top40",
            "name": "NRK MP3",
            "streamURL": "http://lyd.nrk.no/nrk_radio_mp3_mp3_h.m3u",
            "imageURL": "6"
        ],
        [
            "search": "nrk klassisk",
            "desc": "Classical",
            "name": "NRK Klassisk",
            "streamURL": "http://lyd.nrk.no/nrk_radio_klassisk_mp3_h.m3u",
            "imageURL": "10"
        ],
        [
            "search": "nrk alltid nyheter",
            "desc": "News/Talk",
            "name": "NRK Alltid Nyheter",
            "streamURL": "http://lyd.nrk.no/nrk_radio_alltid_nyheter_mp3_h.m3u",
            "imageURL": "11"
        ],
        [
            "search": "nrk folkemusikk",
            "desc": "Folk Music",
            "name": "NRK Folkemusikk",
            "streamURL": "http://lyd.nrk.no/nrk_radio_folkemusikk_mp3_h.m3u",
            "imageURL": "24"
        ],
        [
            "search": "nrk samiradio",
            "desc": "Sami programming",
            "name": "NRK Sami",
            "streamURL": "http://lyd.nrk.no/nrk_radio_sami_mp3_h.m3u",
            "imageURL": "12"
        ],
        [
            "search": "nrk jazz",
            "desc": "Jazz",
            "name": "NRK Jazz",
            "streamURL": "http://lyd.nrk.no/nrk_radio_jazz_mp3_h.m3u",
            "imageURL": "15"
        ],
        [
            "search": "nrk super",
            "desc": "Children's Programmes",
            "name": "NRK Super",
            "streamURL": "http://lyd.nrk.no/nrk_radio_super_mp3_h.m3u",
            "imageURL": "13"
        ],
        
        
        
        [
            "search": "nrk sport",
            "desc": "Sport",
            "name": "NRK Sport",
            "streamURL": "http://lyd.nrk.no/nrk_radio_sport_mp3_h.m3u",
            "imageURL": "14"
        ],
        
        
        [
            "search": "nrk p13",
            "desc": "Rock/Classic rock",
            "name": "NRKP13",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p13_mp3_h.m3u",
            "imageURL": "16"
        ],
        
        [
            "search": "nrk p1 østlandssendingen ",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Østlandssendingen",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_ostlandssendingen_aac_h.m3u",
            "imageURL": "p1ost"
        ],
        
        [
            "search": "nrk p1 buskerud",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Buskerud",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_buskerud_aac_h.m3u",
            "imageURL": "p1busk"
        ],
        
        [
            "search": "nrk p1 finnmark",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Finnmark",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_finnmark_aac_h.m3u",
            "imageURL": "p1fin"
        ],
        
        [
            "search": "nrk p1 hordaland",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Hordaland",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_hordaland_aac_h.m3u",
            "imageURL": "p1hor"
        ],
        
        [
            "search": "nrk p1 møre og romsdal",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Møre og Romsdal",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_more_og_romsdal_aac_h.m3u",
            "imageURL": "p1morog"
        ],
        
        [
            "search": "nrk p1 nordland",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Nordland",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_nordland_aac_h.m3u",
            "imageURL": "p1nord"
        ],
        
        [
            "search": "nrk p1 hedmark og oppland",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Hedmark og Oppland",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_hedmark_og_oppland_aac_h.m3u",
            "imageURL": "p1hed"
        ],
        
        [
            "search": "nrk p1 rogaland",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Rogaland",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_rogaland_aac_h.m3u",
            "imageURL": "p1rog"
        ],
        
        [
            "search": "nrk p1 sogn og fjordane",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Sogn og Fjordane",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_sogn_og_fjordane_aac_h.m3u",
            "imageURL": "p1sogn"
        ],
        
        [
            "search": "nrk p1 sørlandet",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Sørlandet",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_sorlandet_aac_h.m3u",
            "imageURL": "p1sorl"
        ],
        
        [
            "search": "nrk p1 telemark",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Telemark",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_telemark_aac_h.m3u",
            "imageURL": "p1tele"
        ],
        
        [
            "search": "nrk p1 troms",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Troms",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_troms_aac_h.m3u",
            "imageURL": "p1troms"
        ],
        
        [
            "search": "nrk p1 trøndelag",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Trøndelag",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_trondelag_aac_h.m3u",
            "imageURL": "p1trondlag"
        ],
        
        [
            "search": "nrk p1 vestfold",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Vestfold",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_vestfold_aac_h.m3u",
            "imageURL": "p1vest"
        ],
        
        [
            "search": "nrk p1 østfold",
            "desc": "News/Talk/Culture",
            "name": "NRKP1 Østfold",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1_ostfold_aac_h.m3u",
            "imageURL": "p1ostf"
        ],
        
        
        [
            "search": "nrk p1+",
            "desc": "News/Talk/Culture/Oldies",
            "name": "NRKP1+",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p1pluss_mp3_m.m3u",
            "imageURL": "7"
        ],
        
        [
            "search": "nrk p2",
            "desc": "News/Talk",
            "name": "NRKP2",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p2_mp3_h.m3u",
            "imageURL": "9"
        ],
        [
            "search": "nrk p3",
            "desc": "Alternative Rock",
            "name": "NRKP3",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p3_mp3_h.m3u",
            "imageURL": "NRK p3"
        ],
        
        [
            "search": "nrk p3 urørt",
            "desc": "Pop/Contemporary",
            "name": "NRKP3 Urørt",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p3_urort_mp3_m.m3u",
            "imageURL": "urørt"
        ],
        
        [
            "search": "nrk p3 radioresepsjonen",
            "desc": "Humor",
            "name": "NRKP3 Radioresepsjonen",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p3_radioresepsjonen_mp3_m.m3u",
            "imageURL": "Radioresep"
        ],
        
        
        [
            "search": "p4",
            "desc": "Entertainment/Hits",
            "name": "P4",
            "streamURL": "https://p4.p4groupaudio.com/P04_MH",
            "imageURL": "1"
        ],
        [
            "search": "p4 bandit",
            "desc": "Classic rock/Alternative rock",
            "name": "P4 Bandit",
            "streamURL": "https://p11.p4groupaudio.com/P11_MH",
            "imageURL": "27"
        ],
        
        [
            "search": "p5 nonstop hits",
            "desc": "Hits/Top40",
            "name": "P5 Nonstop Hits",
            "streamURL": "https://p5n.p4groupaudio.com/P05AMM",
            "imageURL": "28"
        ],
        
        [
            "search": "p5 hits",
            "desc": "Hits/Top40",
            "name": "P5 Hits",
            "streamURL": "https://p5.p4groupaudio.com/P05_MM",
            "imageURL": "p5 hits"
        ],
        
        [
            "search": "p6 rock",
            "desc": "Rock",
            "name": "P6 Rock",
            "streamURL": "https://p6.p4groupaudio.com/P06_MM",
            "imageURL": "18"
        ],
        
        [
            "search": "p7 klem",
            "desc": "Adult Contemporary",
            "name": "P7 Klem",
            "streamURL": "https://p7.p4groupaudio.com/P07_MM",
            "imageURL": "4"
        ],
        [
            "search": "p8 pop",
            "desc": "Hits/80s",
            "name": "P8 Pop",
            "streamURL": "https://p8.p4groupaudio.com/P08_MM",
            "imageURL": "33"
        ],
        
        [
            "search": "p9 retro",
            "desc": "Classics",
            "name": "P9 Retro",
            "streamURL": "https://p9.p4groupaudio.com/P09_MM",
            "imageURL": "35"
        ],
        
        [
            "search": "p10 country",
            "desc": "Country",
            "name": "P10 Country",
            "streamURL": "https://p10.p4groupaudio.com/P10_MM",
            "imageURL": "country"
        ],
        
        [
            "search": "kiss",
            "desc": "Top40",
            "name": "Kiss",
            "streamURL": "https://live-bauerno.sharp-stream.com/kiss_no_mp3",
            "imageURL": "Kiss"
        ],
        
        [
            "search": "kisstory",
            "desc": "Top40",
            "name": "Kisstory",
            "streamURL": "https://live-bauerno.sharp-stream.com/kisstory_no_mp3",
            "imageURL": "23"
        ],
        
        [
        
        "search": "duen radio",
        "desc": "Hits/Classical",
        "name": "Duen Radio",
        "streamURL": "https://streams.radio.co/s07e510a23/listen",
        "imageURL": "duen-radio"
            
        ],
        
        [
            "search": "ariel radio",
            "desc": "Hits/Classical",
            "name": "Ariel Radio",
            "streamURL": "https://streams.radio.co/sf069f3c03/listen",
            "imageURL": "arielRadio"
        ],
        [
            "search": "radio vinyl",
            "desc": "Hits/Classical",
            "name": "Radio vinyl",
            "streamURL": "http://tx-bauerno.sharp-stream.com/http_live.php?i=vinyl_no_hq",
            "imageURL": "radio-vinyl"
        ],
        
        
        [
            "search": "p24-7 mix",
            "desc": "Easy Listening",
            "name": "P24-7 mix",
            "streamURL": "https://live-bauerno.sharp-stream.com/p247mix_no_mp3",
            "imageURL": "p24-mix"
        ],
        
        [
            "search": "the beat",
            "desc": "Hits/Top40",
            "name": "The Beat",
            "streamURL": "http://stream.thebeat.no/beat128.mp3",
            "imageURL": "theBeat"
        ],
        
        [
            "search": "topp 40",
            "desc": "Hits/Top40",
            "name": "Topp 40",
            "streamURL": "https://live-bauerno.sharp-stream.com/top40_no_mp3",
            "imageURL": "topp 40"
        ],
        
        [
            "search": "nrj",
            "desc": "Hits/Top40",
            "name": "NRJ",
            "streamURL": "https://nrj.p4groupaudio.com/NRJ_MH",
            "imageURL": "3"
        ],
        
        [
            "search": "radio norge",
            "desc": "Adult Contemporary",
            "name": "Radio Norge",
            "streamURL": "https://live-bauerno.sharp-stream.com/radionorge_no_mp3",
            "imageURL": "2"
        ],
        
        [
            "search": "radio rock",
            "desc": "Rock",
            "name": "Radio Rock",
            "streamURL": "https://live-bauerno.sharp-stream.com/radiorock_no_mp3",
            "imageURL": "21"
        ],
        
        
        [
            "search": "radio 102",
            "desc": "World Talk",
            "name": "Radio 102",
            "streamURL": "http://downstream.radio.raw.no:8000/radio102.m3u",
            "imageURL": "Radio102"
        ],
        
        [
            "search": "radio revolt",
            "desc": "Student Radio",
            "name": "Radio Revolt",
            "streamURL": "https://direkte.radiorevolt.no/revolt.aac",
            "imageURL": "Radio Revolt"
        ],
        
        [
            "search": "kristen radio vest",
            "desc": "Christian Contemporary",
            "name": "Kristen Radio Vest",
            "streamURL": "http://5604.cloudrad.io:8268/kristenradiovest.mp3",
            "imageURL": "KristenRadio"
        ],
        
        
        [
            "search": "radio metro",
            "desc": "Adult Contemporary",
            "name": "Radio Metro",
            "streamURL": "http://stream.radiometro.no/metro64.mp3",
            "imageURL": "RadioMetro"
        ],
        
        
        
        [
            "search": "elverum",
            "desc": "Adult Contemporary",
            "name": "ElverumsRadioen",
            "streamURL": "http://109.169.96.11:8000/elverum.mp3",
            "imageURL": "elverumsradioen"
        ],
        [
            "search": "østerdal",
            "desc": "Adult Contemporary",
            "name": "ØsterdalsRadioen",
            "streamURL": "http://109.169.96.11:8000/osterdal.mp3",
            "imageURL": "osterdalsradioen"
        ],
        [
            "search": "solør",
            "desc": "Adult Contemporary",
            "name": "Solør Radioen",
            "streamURL": "http://109.169.96.11:8000/solor.mp3",
            "imageURL": "solør"
        ],
        [
            "search": "solør+",
            "desc": "Adult Contemporary",
            "name": "SolørRadioen+",
            "streamURL": "http://109.169.96.11:8000/solorpluss.mp3",
            "imageURL": "solør+"
        ],
        [
            "search": "trysil",
            "desc": "Adult Contemporary",
            "name": "TrysilRadioen",
            "streamURL": "http://109.169.96.11:8000/trysil.mp3",
            "imageURL": "trysilradioen"
        ],
        
        [
            "search": "rox 90.1",
            "desc": "Rock/Pop",
            "name": "Rox 90.1",
            "streamURL": "http://stream.radiorox.no:8040/listen.pls",
            "imageURL": "rox"
        ],
        
        [
            "search": "ordentlig radio",
            "desc": "World Music",
            "name": "Ordentlig Radio",
            "streamURL": "http://mms-live.online.no/oradio_mp3_m.m3u",
            "imageURL": "ordentlig"
        ]
        
        
    ]
    
    
    
}


