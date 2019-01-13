//
//  MainPageChannels.swift
//  Skurring
//
//  Created by Marius Fagerhol on 12/01/2019.
//  Copyright © 2019 Appzelof. All rights reserved.
//

import UIKit

protocol StationWasLongOrJustPressed {
    func longPressed(spot: Int)
    func pressed(station: Radiostations)
}

class MainPageChannelsCell: UICollectionViewCell {
    
    @IBOutlet weak var holdToChooseChannel: UILabel!
    @IBOutlet weak var choosenChannelImage: UIImageView!
    
    private var stationWasLongOrJustPressedDelegate: StationWasLongOrJustPressed!
    private var currentStation: Radiostations!
    
    func configureCell(station: Radiostations, delegateListener: UIViewController) {
        self.stationWasLongOrJustPressedDelegate = delegateListener as? StationWasLongOrJustPressed
        self.currentStation = station
        self.addLongGesture()
        self.addTapGesture()
        if station.radioStream == "" {
            holdToChooseChannel.isHidden = false
            holdToChooseChannel.text = "Hold to store preset"
            choosenChannelImage.isHidden = true
        } else {
            holdToChooseChannel.isHidden = true
            if let theStationRadioImage = station.radioImage {
                choosenChannelImage.image = UIImage.init(data: theStationRadioImage as Data)
                choosenChannelImage.isHidden = false
                choosenChannelImage.contentMode = .scaleAspectFit
            }
        }
    }
    
    private func addLongGesture() {
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressMethod))
        self.contentView.addGestureRecognizer(longGesture)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureMethod))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapGestureMethod() {
        self.stationWasLongOrJustPressedDelegate.pressed(station: self.currentStation)
    }
    
    @objc private func longPressMethod(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.stationWasLongOrJustPressedDelegate.longPressed(spot: Int(self.currentStation.radioSpot))
        } else {
            return
        }
    }
}
