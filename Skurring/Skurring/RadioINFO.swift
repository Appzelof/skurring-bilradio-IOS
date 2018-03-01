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
            "search": "nrk p3 nationalrapshow",
            "desc": "Rap/Hipop",
            "name": "NRKP3 National Rapshow",
            "streamURL": "http://lyd.nrk.no/nrk_radio_p3_national_rap_show_mp3_h.m3u",
            "imageURL": "NationalRap"
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
            "streamURL": "http://stream.p4.no/p4_mp3_hq",
            "imageURL": "1"
        ],
        [
            "search": "p4 bandit",
            "desc": "Classic rock/Alternative rock",
            "name": "P4 Bandit",
            "streamURL": "http://stream.p4.no/bandit_mp3_hq",
            "imageURL": "27"
        ],
        
        [
            "search": "p5 nonstop hits",
            "desc": "Hits/Top40",
            "name": "P5 Nonstop Hits",
            "streamURL": "http://stream.p4.no/p5nonstophits_mp3_hq",
            "imageURL": "28"
        ],
        
        [
            "search": "p5 oslo",
            "desc": "Hits/Top40",
            "name": "P5 Oslo",
            "streamURL": "http://stream.p4.no/p5oslo_mp3_hq",
            "imageURL": "29"
        ],
        [
            "search": "p5 bergen",
            "desc": "Hits/Top40",
            "name": "P5 Bergen",
            "streamURL": "http://stream.p4.no/p5bergen_mp3_hq",
            "imageURL": "Bergen"
        ],
        [
            "search": "p5 stavanger",
            "desc": "Hits/Top40",
            "name": "P5 Stavanger",
            "streamURL": "http://stream.p4.no/p5stavanger_mp3_hq",
            "imageURL": "Stavanger"
        ],
        [
            "search": "p5 trondheim",
            "desc": "Hits/Top40",
            "name": "P5 Trondheim",
            "streamURL": "http://stream.p4.no/p5trondheim_mp3_hq",
            "imageURL": "31"
        ],
        [
            "search": "p6 rock",
            "desc": "Rock",
            "name": "P6 Rock",
            "streamURL": "http://stream.p4.no/p6_mp3_hq",
            "imageURL": "18"
        ],
        
        [
            "search": "p7 klem",
            "desc": "Adult Contemporary",
            "name": "P7 Klem",
            "streamURL": "http://stream.p4.no/p7_mp3_hq",
            "imageURL": "4"
        ],
        [
            "search": "p8 pop",
            "desc": "Hits/80s",
            "name": "P8 Pop",
            "streamURL": "http://stream.p4.no/p8_mp3_hq",
            "imageURL": "33"
        ],
        
        [
            "search": "p9 retro",
            "desc": "Classics",
            "name": "P9 Retro",
            "streamURL": "http://stream.p4.no/p9_mp3_hq",
            "imageURL": "35"
        ],
        
        [
            "search": "p10 country",
            "desc": "Country",
            "name": "P10 Country",
            "streamURL": "http://stream.p4.no/p10_mp3_hq",
            "imageURL": "country"
        ],
        
        [
            "search": "kiss",
            "desc": "Top40",
            "name": "Kiss",
            "streamURL": "http://stream.bauermedia.no/kiss.mp3",
            "imageURL": "Kiss"
        ],
        
        [
            "search": "kisstory",
            "desc": "Top40",
            "name": "Kisstory",
            "streamURL": "http://stream.bauermedia.no/kisstory.mp3.m3u",
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
            "streamURL": "http://edge-bauersefm-09-gos2.sharp-stream.com/top40_no_hq",
            "imageURL": "topp 40"
        ],
        
        
        
        [
            "search": "nrj",
            "desc": "Hits/Top40",
            "name": "NRJ",
            "streamURL": "http://stream.p4.no/nrj_mp3_hq",
            "imageURL": "3"
        ],
        
        [
            "search": "radio norge",
            "desc": "Adult Contemporary",
            "name": "Radio Norge",
            "streamURL": "http://stream2.sbsradio.no/radionorge.mp3.m3u",
            "imageURL": "2"
        ],
        
        [
            "search": "radio rock",
            "desc": "Rock",
            "name": "Radio Rock",
            "streamURL": "http://stream2.sbsradio.no/radiorock.mp3.m3u",
            "imageURL": "21"
        ],
        [
            "search": "radio norge soft",
            "desc": "Easy Listening",
            "name": "Radio Norge Soft",
            "streamURL": "http://stream.bauermedia.no/radionorgesoft.mp3.m3u",
            "imageURL": "22"
        ],
        
        
        
        
        [
            "search": "radio 102",
            "desc": "World Talk",
            "name": "Radio 102",
            "streamURL": "http://downstream.radio.raw.no:8000/radio102.m3u",
            "imageURL": "Radio102"
        ],
        
        [
            "search": "radio trondheim",
            "desc": "Local",
            "name": "Radio Trondheim",
            "streamURL": "http://nettradio.radiotrondheim.no:8000/lytte",
            "imageURL": "Radio Trondheim"
        ],
        
        [
            "search": "radio revolt",
            "desc": "Student Radio",
            "name": "Radio Revolt",
            "streamURL": "http://streamer.radiorevolt.no:8000/revolt.m3u",
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
            "streamURL": "http://stream.21stventure.com:8100/listen.pls",
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
            "search": "scansat",
            "desc": "Scandinavian Satelite Radio",
            "name": "Scansat",
            "streamURL": "http://stream.radioh.no:443/scan128.m3u",
            "imageURL": "Scansat"
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


