//
//  VideoPlayer.swift
//  skurring
//
//  Created by Daniel Bornstedt on 02/12/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import AVFoundation
import CoreVideo
import UIKit

protocol VideoAnimationListener: class {
    func videoDidStopAnimating()
    func videoAnimating()
}

extension VideoAnimationListener {
    func videoDidStopAnimating() {}
    func videoAnimating() {}
}

class VideoPlayer: UIView, MediaPlayerControls {

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    weak var videoAnimatorListener: VideoAnimationListener?

    init() {
        super.init(frame: .zero)
    }

    func play() {
        prepareToPlay()
        player?.play()
    }


    func pause() {
        player?.pause()
    }

    func loopVideo() {
        play()
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { notification in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }

    private func prepareToPlay() {
        guard let path = Bundle
            .main
            .path(forResource: "tutorial_1", ofType: "mov")
        else { return }

        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resize
        playerLayer?.masksToBounds = true
        layer.addSublayer(playerLayer ?? CALayer())
    }

    private func show() {
        UIView.animate(withDuration: 3) {
            self.alpha = 1
            self.videoAnimatorListener?.videoAnimating()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
