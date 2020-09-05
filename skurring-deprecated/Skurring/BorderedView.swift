//
//  BorderedView.swift
//  Skurring
//
//  Created by Marius Fagerhol on 22/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class BorderedView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
}
