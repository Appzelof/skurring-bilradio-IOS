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
    
    public var theObject: MainScreenRadioObjects!
    
    func configureCell(radioObject: MainScreenRadioObjects) {
        theObject = radioObject
        theRadioImage.image = UIImage(named: radioObject.image)
    }
    
}
