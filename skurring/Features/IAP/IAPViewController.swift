//
//  IAPViewController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 01/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import UIKit

final class IAPViewController: UIViewController {

    private lazy var subscriptionButton = makeSubscriptionButton()
    private let restorePurchaseButton = UIButton()
    private let purchaseCard = IAPView()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = StyleGuideFactory.current.colors.backgroundColor
        let subviews = [
            subscriptionButton,
            purchaseCard
        ]
        subviews.forEach(view.addSubview)
        addConstraints()
    }

    private func makeSubscriptionButton() -> SkurringButton {
        let button = SkurringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(subscribe), for: .primaryActionTriggered)
        button.setTitle("Bli med nå", for: .normal)
        return button
    }

    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }

    private func addConstraints() {
        NSLayoutConstraint.activate(
            [
                purchaseCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                purchaseCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                purchaseCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                purchaseCard.heightAnchor.constraint(equalToConstant: 300),

                subscriptionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subscriptionButton.heightAnchor.constraint(equalToConstant: 50),
                subscriptionButton.widthAnchor.constraint(equalToConstant: 200),
                subscriptionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            ]
        )
    }

    @objc
    private func subscribe() {
        IAPHelper.shared.purchase(productID: "com.appzelof.skurring.subscription")
    }
}
