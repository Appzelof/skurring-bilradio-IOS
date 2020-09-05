//
//  PlayRadioCell.swift
//  Skurring
//
//  Created by Marius Fagerhol on 02/02/2018.
//  Copyright © 2018 Appzelof. All rights reserved.
//

import UIKit

class PlayRadioCell: UICollectionViewCell {
    
    @IBOutlet weak var theRadioImage: UIImageView!
        
    func configureCell(radioObject: Radiostations) {
        theRadioImage.image = UIImage.init(data: radioObject.radioImage! as Data)
    }
    
}
