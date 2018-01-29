//
//  ShadowCircularButton.swift
//  Skurring
//
//  Created by Marius Fagerhol on 22/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class ShadowCircularButton: UIButton {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.imageView?.contentMode = .scaleAspectFit
    
    }
}
