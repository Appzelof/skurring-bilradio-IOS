//
//  SkurringButton.swift
//  skurring
//
//  Created by Daniel Bornstedt on 27/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import UIKit

class SkurringButton: UIButton {

    let alphaView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        alphaView.frame = frame
        addSubview(alphaView)
        sendSubviewToBack(alphaView)
        alphaView.backgroundColor = .black

        alpha = 0.8
        layer.cornerRadius = 20
        backgroundColor = .orange
        titleLabel?.textColor = .gray
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
