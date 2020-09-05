//
//  IAPViewController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 01/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import UIKit

class IAPViewController: UIViewController {

    private lazy var premiumHeaderCard = makePremiumHeaderCard()
    private lazy var subscriptionButton = makeSubscriptionButton()
    private let restorePurchaseButton = UIButton()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()

        let subviews = [
            premiumHeaderCard,
            subscriptionButton,
            restorePurchaseButton
        ]
        subviews.forEach(view.addSubview)
        addConstraints()
    }

    private func makePremiumHeaderCard() -> UIView {
        let view = UIView()
        view.backgroundColor = StyleGuideFactory.current.colors.backgroundColor
        return view
    }

    private func makeSubscriptionButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(subscribe), for: .primaryActionTriggered)
        button.setTitle("Enroll Now", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 10
        return button
    }

    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "La musikken flyte med skurring"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }

    private func addConstraints() {
        NSLayoutConstraint.activate(
            [
                subscriptionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                subscriptionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                subscriptionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                subscriptionButton.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
    }

    @objc
    private func subscribe() {
        IAPHelper.shared.purchase(productID: "com.appzelof.skurring.subscription")
    }
}
