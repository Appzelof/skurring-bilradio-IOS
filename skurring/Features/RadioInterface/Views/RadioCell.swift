//
//  RadioCell.swift
//  skurring
//
//  Created by Daniel Bornstedt on 08/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

protocol RadioButtonHandler: class {
    func didTapRadioButton(cell: RadioCell)
    func didLongPressRadioButton(cell: RadioCell)
} 

final class RadioCell: UICollectionViewCell {
    weak var radioButtonDelegate: RadioButtonHandler?

    private let styleGuide = StyleGuideFactory.current
    private let videoPlayer = VideoPlayer()

    private let radioButton = UIButton()
    private let radioNameLabel = UILabel()
    private let radioImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        configurePrerequisits()
        configureRadioButton()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        contentView.addSubview(radioButton)
        contentView.addSubview(radioNameLabel)
        contentView.addSubview(radioImageView)
    }

    private func configurePrerequisits() {
        radioButton.createRadioButton()

        backgroundColor = .clear
        radioNameLabel.textAlignment = .center
        radioImageView.contentMode = .scaleAspectFit
        radioImageView.image = nil
    }

    private func addConstraints() {
        videoPlayer.pinToEdges()
        radioButton.pinToEdgesWithConstant(constant: 5)
        radioNameLabel.pinToEdges()
        radioImageView.pinToEdgesWithConstant(constant: 35)
    }

    private func configureRadioButton() {
        let longTapGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didLongPressRadioButton(cell:)
            )
        )

        radioButton.addTarget(
            self,
            action: #selector(didTapRadioButton(cell:)),
            for: .primaryActionTriggered
        )

        radioButton.addGestureRecognizer(longTapGesture)
    }

    func contentIsEmpty() -> Bool {
        return radioImageView.image == nil
    }

    func updateUI(radioName: String?, radioImage: UIImage?, radioURL: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.radioImageView.image = radioImage
            if self.radioImageView.image == nil {
                self.radioNameLabel.text = "Hold"
                self.setNeedsLayout()
            } else {
                self.radioNameLabel.text = ""
            }
        }
    }
}

extension RadioCell: RadioButtonHandler {
    @objc func didLongPressRadioButton(cell: RadioCell) {
        if radioButton.gestureRecognizers?.contains(where: { $0.state == .began }) == true {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.5, options: .curveLinear) {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.radioButton.alpha = 0.2
            } completion: { (_) in
                self.radioButtonDelegate?.didLongPressRadioButton(cell: self)
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveLinear) {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.radioButton.alpha = 1
                } completion: { (_) in }
            }
        }
    }

    @objc func didTapRadioButton(cell: RadioCell) {
        self.radioButtonDelegate?.didTapRadioButton(cell: self)
    }
}

