//
//  Constraints.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func pinToEdges() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superView = self.superview else { return }
        NSLayoutConstraint.activate(
            [
                leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
                trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor)

            ]
        )
    }

    func pinToEdgesWithConstant(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superView = self.superview else { return }
        NSLayoutConstraint.activate(
            [
                leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant),
                topAnchor.constraint(equalTo: superView.topAnchor, constant: constant),
                trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -constant),
                bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -constant)

            ]
        )
    }

    func pinToEdgesWithSafeArea(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superView = self.superview else { return }
        NSLayoutConstraint.activate(
            [
                leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: constant),
                topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: constant),
                trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -constant),
                bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -constant)

            ]
        )

    }
}
