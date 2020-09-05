//
//  drivingToolsCell.swift
//  Skurring
//
//  Created by Marius Fagerhol on 12/01/2019.
//  Copyright © 2019 Appzelof. All rights reserved.
//

import UIKit

protocol ParkingOrEmergencyWasPressed {
    func parkingWasPressed()
    func emergencyWasPressed()
    func trafficMessages()
}

class DrivingToolkitCell: UICollectionViewCell {
    
    @IBOutlet weak var emergencyBtn: UIButton!
    @IBOutlet weak var parkingBtn: UIButton!
    @IBOutlet weak var trafficInfoImage: UIImageView!
    @IBOutlet weak var animationButton: UIButton!
    
    private var parkingOrEmergencyWasPressedDelegate: ParkingOrEmergencyWasPressed!
    
    func configureCell(protocolListener: UIViewController) {
        trafficInfoImage.image = UIImage.init(named: "VegMeldinger")
        self.animationButton.setImage(UIImage.init(named: "BlackButtonPNG"), for: .highlighted)
        self.parkingOrEmergencyWasPressedDelegate = protocolListener as? ParkingOrEmergencyWasPressed
    }
    
    @IBAction func emergencyButton(_ sender: UIButton!) {
        self.parkingOrEmergencyWasPressedDelegate.emergencyWasPressed()
    }
    
    @IBAction func parkingBtn(_ sender: UIButton!) {
        self.parkingOrEmergencyWasPressedDelegate.parkingWasPressed()
    }
    
    @IBAction func trafficMessages(_ sender: UIButton!) {
        self.parkingOrEmergencyWasPressedDelegate.trafficMessages()
    }
    
}
