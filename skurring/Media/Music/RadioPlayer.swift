//
//  RadioPlayer.swift
//  skurring
//
//  Created by Daniel Bornstedt on 09/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

protocol MetaDataHandlerDelegate: class {
    func fetchMetaData(metaData: String?)
}
// TODO: - Add observer to get metadata
final class RadioPlayer: NSObject, MediaPlayerControls {

    private var player: AVPlayer?
    private var commandCenter: CommandCenter?
    private var channelName: String?
    weak var metaDataHandlerDelegate: MetaDataHandlerDelegate?

    init(radioStream: String, channelName: String) {
        super.init()
        self.channelName = channelName
        self.prepareToPlay(radioStream: radioStream)
    }

    private func prepareToPlay(radioStream: String) {
        guard let url = URL(string: radioStream) else { return }
        let avPlayerItem = AVPlayerItem(url: url)
        let metaDataOutput = AVPlayerItemMetadataOutput()
        metaDataOutput.setDelegate(self, queue: .main)
        avPlayerItem.add(metaDataOutput)
        player = AVPlayer(playerItem: avPlayerItem)
        commandCenter = CommandCenter(player: player)
    }

    func play() {
        guard player?.rate == 0 else { return }
        player?.play()
    }

    func pause() {
        guard player?.rate != 0 else { return }
        player?.pause()
    }

    deinit {
        commandCenter?.release()
        player = nil
    }
}

extension RadioPlayer: AVPlayerItemMetadataOutputPushDelegate {
    func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        let metaDataItems = groups.first.map({ $0.items })
        let info = metaDataItems?.first(where: { $0.stringValue != nil })?.stringValue
        commandCenter?.setupNowPlayingInfo(radioStationName: nil, metaData: nil)
        metaDataHandlerDelegate?.fetchMetaData(metaData: nil)
        if let data = info {
            commandCenter?.setupNowPlayingInfo(radioStationName: channelName, metaData: data)
            metaDataHandlerDelegate?.fetchMetaData(metaData: data)
        }
    }
}


