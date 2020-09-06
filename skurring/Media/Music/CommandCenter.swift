//
//  CommandCenter.swift
//  skurring
//
//  Created by Daniel Bornstedt on 07/12/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import MediaPlayer

final class CommandCenter {
    private let commandCenter = MPRemoteCommandCenter.shared()
    private let audioSession = AVAudioSession.sharedInstance()
    private var player: AVPlayer?

    init(player: AVPlayer?) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.player = player
        enablePlayback()
        setupRemoteTransporterControls()
    }

    private func enablePlayback() {
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("Playback failed")
        }
        return
    }

    private func setupRemoteTransporterControls() {
        commandCenter.stopCommand.isEnabled = true
        commandCenter.playCommand.isEnabled = true
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.isEnabled = true

        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if self.player?.rate == 0.0 {
                print("Play")
                self.player?.play()
                return .success
            }
            return .commandFailed
        }

        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            if self.player?.rate != 0.0 {
                print("pause")
                self.player?.pause()
                return .success
            }
            return .commandFailed
        }

    }

    func setupNowPlayingInfo(radioStationName: String?, metaData: String?) {
        let logo = UIImage().getAppIcon() ?? UIImage()
        let artWork = MPMediaItemArtwork(boundsSize: logo.size) { (size) -> UIImage in
            return logo
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: radioStationName ?? "",
            MPMediaItemPropertyArtwork: artWork,
            MPMediaItemPropertyArtist: metaData ?? "",
        ]
    }

    func release() {
        player = nil
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
    }
}
