//
//  IAPView.swift
//  skurring
//
//  Created by Daniel Bornstedt on 27/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import UIKit

class IAPView: UIView {

    private var imageView = UIImageView()
    private var descriptionLabel = UILabel()
    private var priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUIPrerequisits()
        setupUI()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUIPrerequisits() {
        let views = [imageView, descriptionLabel, priceLabel]
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        views.forEach(addSubview)
    }

    private func setupUI() {
        backgroundColor = .black
        alpha = 0.8
        layer.cornerRadius = 30
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        descriptionLabel.text = "Skurring Premium"
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center

        priceLabel.textColor = .white
        priceLabel.textAlignment = .center
        priceLabel.text = "kr 49,- | måned"

        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)

        imageView.image = UIImage(named: "crown")
        imageView.contentMode = .scaleAspectFit
    }

    private func addConstraints() {
        NSLayoutConstraint.activate(
            [
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 50),

                descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),

                priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 10),
                priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor)

            ]
        )
    }
}
