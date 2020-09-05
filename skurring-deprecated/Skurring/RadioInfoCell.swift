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
    
    private var dataTask: URLSessionDataTask?

    func updateUI(information: RadioPlayer){
        self.radioInfo.text = information.radioINFO
        self.theImage.image = UIImage(named: information.imgPNG)
    }


}
