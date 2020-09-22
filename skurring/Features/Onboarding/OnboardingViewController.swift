//
//  OnboardingViewController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 21/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController, UIPageViewControllerDelegate {

    private lazy var pageController: UIPageControl = createPageControl()
    private lazy var collectionView: UICollectionView = createCollectionView()

    private let dummyData: [String] = [
        "Dette er en test",
        "Du er kul",
        "Skurring er best"
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

        cell.updateText(description: dummyData[indexPath.row])

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIPRerequisits()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUIPRerequisits() {
        addSubview(descriptionLabel)
        descriptionLabel.pinToEdges()
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 5
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 50)
    }

    func updateText(description: String) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = description
        }
    }
}

