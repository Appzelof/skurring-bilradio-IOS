//
//  EmergencyCell.swift
//  Skurring
//
//  Created by Marius Fagerhol on 21/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit
class EmergencyCell: UITableViewCell {
    
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    
    func configureCell(info: Options) {
        phoneImage.image = UIImage(named: info.phoneImage)
        phoneNumber.text = getNumber(numberString: info.number)
        companyImage.image = UIImage(named: info.companyImage)
    }
    
    private func getNumber(numberString: String) -> String {
        return numberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
}
