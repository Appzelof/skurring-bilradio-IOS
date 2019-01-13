//
//  RadioInfoCell.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 19.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class RadioInfoCell: UITableViewCell {
    
    @IBOutlet weak var radioInfo: UILabel!
    @IBOutlet weak var theImage: UIImageView!

    func updateUI(information: RadioPlayer){
        self.theImage.image = UIImage.init(named: information.imgPNG)
        self.radioInfo.text = information.radioINFO
    }


}
