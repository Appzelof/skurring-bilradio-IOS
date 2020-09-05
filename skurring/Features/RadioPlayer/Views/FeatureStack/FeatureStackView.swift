//
//  FeatureStack.swift
//  skurring
//
//  Created by Daniel Bornstedt on 11/12/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class FeatureStackView: UIStackView {
    private let styleGuide = StyleGuideFactory.current

    private lazy var airplayButton = createStackButton(image: "airplay")

    init() {
        super.init(frame: .zero)
        configurePrerequisits()
        addTargets()
        
        addArrangedSubview(airplayButton)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum Orientation {
        case landscape
        case portrait
    }

    private func configurePrerequisits() {
        translatesAutoresizingMaskIntoConstraints = false
        semanticContentAttribute = .forceLeftToRight
        contentMode = .scaleAspectFit
        distribution = .fillEqually
    }

    private func addTargets() {
        airplayButton.addTarget(self, action: #selector(showAirPlayView), for: .primaryActionTriggered)
    }

    private func createStackButton(image: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: image), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit

        return button
    }

    @objc func showAirPlayView() {
        let rect = CGRect(x: -100, y: 0, width: 0, height: 0)
        let airplayVolume = MPVolumeView(frame: rect)
        self.addSubview(airplayVolume)
        for view: UIView in airplayVolume.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
        airplayVolume.removeFromSuperview()
    }

    func updateAxis(orientation: Orientation) {
        switch orientation {
        case .portrait:
            axis = .horizontal
        case .landscape:
            axis =  .vertical
        }
    }
}

