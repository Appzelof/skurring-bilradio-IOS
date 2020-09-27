//
//  OnboardingViewController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 21/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import UIKit

fileprivate struct OnboardingData {
    let videoName: String?
    let containsVideo: Bool
    let imageName: String?
    let description: String

    init(videoName: String? = nil, imageName: String? = nil, description: String, containsVideo: Bool = false) {
        self.videoName = videoName
        self.imageName = imageName
        self.description = description
        self.containsVideo = containsVideo
    }
}

final class OnboardingViewController: UIViewController, UIPageViewControllerDelegate {

    private lazy var pageControl: UIPageControl = createPageControl()
    private lazy var collectionView: UICollectionView = createCollectionView()
    private lazy var nextbutton: SkurringButton = createNextButton()

    private let onboardingData = [
        OnboardingData(imageName: "skurring.png", description: "Hei og velkommen til Skurring"),
        OnboardingData(videoName: "tutorial_1.mov", description: "Velg stasjon ved å holde radioknappen inne", containsVideo: true),
        OnboardingData(description: "Skurring Premium")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIPrerequisits()
        addConstraints()
    }

    private func createCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: ConstantHelper.onboardingCell)
        return collectionView
    }

    private func createPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = onboardingData.count
        pageControl.addTarget(
            self,
            action: #selector(pageControlSelectionAction),
            for: .primaryActionTriggered
        )
        return pageControl
    }

    private func createNextButton() -> SkurringButton {
        let button = SkurringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonSelectionAction), for: .primaryActionTriggered)
        button.setTitle("Neste", for: .normal)
        return button
    }

    private func configureUIPrerequisits() {
        view.backgroundColor = .black
        let views = [pageControl, collectionView, nextbutton]
        views.forEach(view.addSubview)
    }

    @objc
    private func buttonSelectionAction() {
        if pageControl.currentPage != pageControl.numberOfPages - 1 {
            let page: Int? = pageControl.currentPage + 1
            var frame: CGRect = collectionView.frame
            frame.origin.x = frame.size.width * CGFloat(page ?? 0)
            frame.origin.y = 0
            pageControl.currentPage = page ?? 0
            pageControl.currentPage == 2
                ? nextbutton.setTitle("Kom i gang", for: .normal)
                : nextbutton.setTitle("Neste", for: .normal)

            collectionView.scrollRectToVisible(frame, animated: true)

        } else {
            self.dismiss(animated: true)
        }
    }

    @objc
    private func pageControlSelectionAction() {
        let page: Int? = pageControl.currentPage
        var frame: CGRect = collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        pageControl.currentPage == 2
            ? nextbutton.setTitle("Kom i gang", for: .normal)
            : nextbutton.setTitle("Neste", for: .normal)

        collectionView.scrollRectToVisible(frame, animated: true)
    }

    private func addConstraints() {

        NSLayoutConstraint.activate(

            [
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 1.5),

                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                pageControl.heightAnchor.constraint(equalToConstant: 50),
                pageControl.widthAnchor.constraint(equalToConstant: 200),

                nextbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
                nextbutton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                nextbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
                nextbutton.heightAnchor.constraint(equalToConstant: 50)

            ]
        )

    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ConstantHelper.onboardingCell,
                for: indexPath) as? OnboardingCell
            else { return UICollectionViewCell() }

        cell.updateUI(onboardingData: onboardingData[indexPath.row])

        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.collectionView.frame.size.width
        pageControl.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)

        pageControl.currentPage == 2
            ? nextbutton.setTitle("Kom i gang", for: .normal)
            : nextbutton.setTitle("Neste", for: .normal)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

fileprivate final class OnboardingCell: UICollectionViewCell {
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let phoneImageView = UIImageView()

    let videoPlayerView = VideoPlayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIPrerequisits()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUIPrerequisits() {
        addSubview(descriptionLabel)
        addSubview(imageView)
        addSubview(videoPlayerView)
        addSubview(phoneImageView)

        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFit
        phoneImageView.contentMode = .scaleAspectFit
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 30)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 5
    }

    private func addConstraints() {
        NSLayoutConstraint.activate(
            [
                descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 400),
                imageView.widthAnchor.constraint(equalToConstant: 400),

                videoPlayerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
                videoPlayerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                videoPlayerView.heightAnchor.constraint(equalToConstant: 350),
                videoPlayerView.widthAnchor.constraint(equalToConstant: 165),

                phoneImageView.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor),
                phoneImageView.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor),
                phoneImageView.heightAnchor.constraint(equalToConstant: 400),
                phoneImageView.widthAnchor.constraint(equalToConstant: 350)

            ]
        )
    }

    func updateUI(onboardingData: OnboardingData) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = onboardingData.description
            self.imageView.image = UIImage(named: onboardingData.imageName ?? "")
            if onboardingData.containsVideo {
                self.videoPlayerView.loopVideo()
                self.phoneImageView.image = UIImage(named: "iphone.png")
            }
        }
    }
}

