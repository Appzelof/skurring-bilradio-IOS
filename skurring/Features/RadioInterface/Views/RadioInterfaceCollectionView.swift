//
//  RadioInterfaceCollectionView.swift
//  skurring
//
//  Created by Daniel Bornstedt on 05/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class RadioInterfaceCollectionView: UICollectionView {

    var savedRadioStations: [NSManagedObject]? = []

    private var cellAmount: Int?
    private var radioStationsCache: [RadioObject] = []
    private var interFaceController: RadioInterfaceViewController?
    private let styleGuide = StyleGuideFactory.current
    private let coreDataManager = CoreDataManager()

    init(interfaceController: RadioInterfaceViewController) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        interfaceController.deviceRotationHandler = self
        self.interFaceController = interfaceController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCollectionView() {
        delegate = self
        dataSource = self
        isScrollEnabled = false
        backgroundColor = .clear
        register(RadioCell.self, forCellWithReuseIdentifier: ConstantHelper.radioCell)
    }

    func updateCellAmount() {
        cellAmount = UIWindow().windowScene?.interfaceOrientation.isLandscape == true
            ? ConstantHelper.iphoneCellLandscapeAmount
            : ConstantHelper.iphoneCellPortraitAmount
        configureCollectionView()
    }
}

extension RadioInterfaceCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellAmount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = dequeueReusableCell(withReuseIdentifier: ConstantHelper.radioCell, for: indexPath) as? RadioCell {
            cell.radioButtonDelegate = self
            radioStationsCache.removeAll()
            cell.updateUI(radioName: nil, radioImage: nil, radioURL: nil)

            if let savedRadioStations = savedRadioStations {
                for stations in savedRadioStations {

                    let buttonTag = stations.value(forKey: ConstantHelper.buttonTag) as? Int
                    let radioName = stations.value(forKey: ConstantHelper.radioName) as? String ?? ""
                    let imageData = stations.value(forKey: ConstantHelper.radioImageData) as? Data ?? Data()
                    let radioURL = stations.value(forKey: ConstantHelper.radioURL) as? String ?? ""
                    let radioHQURL = stations.value(forKey: ConstantHelper.radioHQURL) as? String ?? ""
                    let image = UIImage(data: imageData)

                    let radioObject = RadioObject(
                        buttonTag: buttonTag ?? 0,
                        image: image ?? UIImage(),
                        name: radioName,
                        radioCountry: "",
                        radioURL: radioURL,
                        radioHQURL: radioHQURL
                    )

                    radioStationsCache.append(radioObject)

                    if stations.value(forKey: ConstantHelper.buttonTag) as? Int == indexPath.row {
                        cell.updateUI(radioName: radioName, radioImage: image, radioURL: radioURL)
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension RadioInterfaceCollectionView: DeviceRotationHandler {
    func handleLandscapeRotation(isLandscape: Bool) {
        cellAmount = isLandscape
            ? ConstantHelper.iphoneCellLandscapeAmount
            : ConstantHelper.iphoneCellPortraitAmount
    }
}

//MARK: - CollectionViewCell resizing
extension RadioInterfaceCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isLandscape = UIWindow().windowScene?.interfaceOrientation.isLandscape == true
        return calculateCellSize(isLandscape: isLandscape, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    private func calculateCellSize(isLandscape: Bool, indexPath: IndexPath) -> CGSize {
        let offset = 0
        var normalSize = CGSize()
        var fullSize = CGSize()

        if isLandscape {
            return CGSize(width: frame.width / 5, height: frame.height / 2.1)
        } else {
            normalSize = CGSize(width: frame.width / 2, height: frame.height / 5.3)
            fullSize = CGSize(width: frame.width, height: frame.height / 5.3)
            return (indexPath.row % 3 + offset) == 0 ? fullSize : normalSize
        }
    }
}

extension RadioInterfaceCollectionView: RadioButtonHandler {
    func didLongPressRadioButton(cell: RadioCell) {
        guard
            indexPath(for: cell) != nil,
            let buttonTag = indexPath(for: cell)?.row
        else { return }

        //Reloads data when VC is dismissed.
        let radioStationsViewController = RadioStationsViewController { self.reloadData() }

        radioStationsViewController.modalPresentationStyle = .fullScreen
        radioStationsViewController.setButtonTag(tag: buttonTag)

        interFaceController?.show(radioStationsViewController, sender: self)

        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    func didTapRadioButton(cell: RadioCell) {
        guard
            let indexPath = indexPath(for: cell),
            !radioStationsCache.isEmpty,
            !cell.contentIsEmpty()
        else {
            interFaceController?.show(
                AlertManager.shared.noRadioStationSavedAlert()
                , sender: self
            )
            return
        }

        let radioPlayerViewController = RadioPlayerViewController(
            for: indexPath.row,
            radioStations: radioStationsCache
        )

        radioPlayerViewController.radioPlayerViewControllerDelegate = self

        interFaceController?.show(radioPlayerViewController, sender: self)
    }
}


extension RadioInterfaceCollectionView: RadioPlayerViewControllerHandler {
    func playerViewControllerDidDismiss() {
        UIView.animate(withDuration: 0.3) {
            self.interFaceController?.view.backgroundColor =
                self.styleGuide.colors.backgroundColor
        }
    }

    func playerViewControllerDidShow() {
        UIView.animate(withDuration: 0.3) {
            self.interFaceController?.view.backgroundColor =
                self.styleGuide.colors.buttonBackgroundColor
        }
    }
}



