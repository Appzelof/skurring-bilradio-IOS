//
//  RadioPlayer.swift
//  Skurring
//
//  Created by Marius Fagerhol on 25/02/17.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import MediaPlayer

struct Player {
    static let radio = MPMoviePlayerController()
}

struct CurrentPlayingTracks {
    var artistName = ""
    var songName = ""
}

func setUpPlayer() {
    Player.radio.view.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    Player.radio.view.sizeToFit()
    Player.radio.movieSourceType = .streaming
    Player.radio.isFullscreen = false
    Player.radio.shouldAutoplay = true
    Player.radio.allowsAirPlay = true
    Player.radio.prepareToPlay()
    Player.radio.controlStyle = .none
    
}

//Just in case noen klikker på sleep mens radioen spiller av, så stopper ikke radioen, setter også opp bluetooth her
func setUpBackgroundMode() {
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
    } catch let err as NSError {
        print("Noe gikk galt, dette er err: \(err.debugDescription)")
    }
    
    do {
        try AVAudioSession.sharedInstance().setActive(true)
    } catch let err2 as NSError {
        print("Set Active Error: \(err2.debugDescription)")
    }
}


func beginRecievingControllEvents(VC: UIViewController) {
    UIApplication.shared.beginReceivingRemoteControlEvents()
    VC.becomeFirstResponder()
}

private var getSongImageUrl = DownloadCurrentArtImage()
private var getSongImage = makeImageFromUrl()

func updateLockScreen(Artist: String, songName: String, channelName: String) {
    if Artist == "" || songName == "" {
        updateTheLockscreen(songName: "", channelName: channelName, artWorkImage: getAppIcon())
    } else {
        updateTheLockscreen(songName: songName, channelName: channelName, artWorkImage: getAppIcon())
        getSongImageUrl.DownloadImageUrl(url: "https://itunes.apple.com/search?term=\(Artist)+\(songName)&entity=song") { (imgUrl) in
            getSongImage.makeImage(url: imgUrl, imageComplete: { (songImage) in
                updateTheLockscreen(songName: songName, channelName: channelName, artWorkImage: songImage)
            })
        }
    }
}

private func updateTheLockscreen(songName: String, channelName: String, artWorkImage: UIImage) {
    let artWork = MPMediaItemArtwork.init(image: artWorkImage)
    MPNowPlayingInfoCenter.default().nowPlayingInfo = [
        MPMediaItemPropertyTitle: songName,
        MPMediaItemPropertyArtist: channelName,
        MPMediaItemPropertyArtwork: artWork
    ]
}
