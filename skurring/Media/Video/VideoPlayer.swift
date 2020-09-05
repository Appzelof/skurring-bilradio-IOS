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
        alpha = 0
    }

    func play() {
        prepareToPlay()
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    private func prepareToPlay() {
        guard let path = Bundle
            .main
            .path(forResource: "audio", ofType: "mp4")
        else { return }

        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resize
        playerLayer?.masksToBounds = true
        layer.addSublayer(playerLayer ?? CALayer())
        handleAnimationsBasedOnPlayTime()
    }

    private func handleAnimationsBasedOnPlayTime(){
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main, using: { (time) in
            guard let player = self.player else { return }
            if player.status == .readyToPlay {
                switch time.seconds {
                case 1...2:
                    self.show()
                case 5...6:
                    self.hide()
                default:
                    return
                }
            }
        })
    }

    private func hide() {
        let duration = 3.0
        UIView.animate(withDuration: duration) {
            self.alpha = 0
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + duration) {
                self.videoAnimatorListener?.videoDidStopAnimating()
            }
        }
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
