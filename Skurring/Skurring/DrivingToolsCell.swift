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
}

class DrivingToolkitCell: UICollectionViewCell {
    
    @IBOutlet weak var emergencyBtn: UIButton!
    @IBOutlet weak var parkingBtn: UIButton!
    @IBOutlet weak var trafficInfoImage: UIImageView!
    
    private var parkingOrEmergencyWasPressedDelegate: ParkingOrEmergencyWasPressed!
    
    func configureCell(protocolListener: UIViewController) {
        trafficInfoImage.image = UIImage.init(named: "VegMeldinger")
        self.parkingOrEmergencyWasPressedDelegate = protocolListener as? ParkingOrEmergencyWasPressed
    }
    
    @IBAction func emergencyButton(_ sender: UIButton!) {
        self.parkingOrEmergencyWasPressedDelegate.emergencyWasPressed()
    }
    
    @IBAction func parkingBtn(_ sender: UIButton!) {
        self.parkingOrEmergencyWasPressedDelegate.parkingWasPressed()
    }
    
}
