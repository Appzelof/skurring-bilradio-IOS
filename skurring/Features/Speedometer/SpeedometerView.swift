//
//  LocationManager.swift
//  skurring
//
//  Created by Daniel Bornstedt on 20/04/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Combine

final class SpeedometerView: UIView {
    
    private lazy var speedLabel: UILabel = createLabel()

    private var viewModel = SpeedometerViewModel()
    private var cancellable = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(speedLabel)
        addConstraints()

        viewModel.attributedSpeedInfoSubject
            .sink { [weak self] in
                guard let self = self else { return }
                self.speedLabel.attributedText = $0
            }
            .store(in: &cancellable)
    }

    private func addConstraints() {
        speedLabel.pinToEdges()
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        label.numberOfLines = 2

        return label
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

