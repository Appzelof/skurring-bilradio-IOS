//
//  RadioButton.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func createRadioButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = StyleGuideFactory.current.colors.buttonBackgroundColor
        self.layer.cornerRadius = 19
    }
}
