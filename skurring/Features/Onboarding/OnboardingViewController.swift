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
    let imageName: String?
    let description: String

    init(videoName: String? = nil, imageName: String? = nil, description: String) {
        self.videoName = videoName
        self.imageName = imageName
        self.description = description
    }
}

final class OnboardingViewController: UIViewController, UIPageViewControllerDelegate {

    private lazy var pageController: UIPageControl = createPageControl()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private let dummyData: [String] = [
        "Hei og velkommen til Skurring",
        "Velg kanal",
        "Trykk på radioknappen for å spille"
    ]

    private let onboardingImages: [String] = [
        "happy_music.svg",
        "listening.svg",
        "test"
    ]

    private let data = [
        OnboardingData(imageName: "happy_music.svg", description: "Hei og velkommen til skurring"),
        OnboardingData(videoName: "velg-kanal.mov", description: "Velg kanal"),
        OnboardingData(videoName: "", imageName: "", description: "Spill av")
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
        pageControl.numberOfPages = dummyData.count
        pageControl.addTarget(
            self,
            action: #selector(pageControlSelectionAction(_:)),
            for: .primaryActionTriggered
        )
        return pageControl
    }

    private func configureUIPrerequisits() {
        view.backgroundColor = .black
        let views = [pageController, collectionView]
        views.forEach(view.addSubview)
    }

    @objc
    private func pageControlSelectionAction(_ sender: UIPageControl) {
        let page: Int? = sender.currentPage
        var frame: CGRect = collectionView.frame
        frame.origin.x = frame.size.width * CGFloat(page ?? 0)
        frame.origin.y = 0
        collectionView.scrollRectToVisible(frame, animated: true)
    }

    private func addConstraints() {

        NSLayoutConstraint.activate(

            [
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 1.5),

                pageController.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
                pageController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                pageController.heightAnchor.constraint(equalToConstant: 50),
                pageController.widthAnchor.constraint(equalToConstant: 200)

            ]
        )

    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ConstantHelper.onboardingCell,
                for: indexPath) as? OnboardingCell
            else { return UICollectionViewCell() }

        cell.updateUI(onboardingData: data[indexPath.row])

        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.collectionView.frame.size.width
        pageController.currentPage = Int(self.collectionView.contentOffset.x / pageWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

fileprivate final class OnboardingCell: UICollectionViewCell {
    let descriptionLabel = UILabel()
    let imageView = UIImageView()

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

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
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

                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
                imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
                imageView.heightAnchor.constraint(equalToConstant: 300),
                imageView.widthAnchor.constraint(equalToConstant: 300)
            ]
        )
    }

    func updateUI(onboardingData: OnboardingData) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = onboardingData.description
            self.imageView.image = UIImage(named: onboardingData.imageName ?? "")
        }
    }
}

