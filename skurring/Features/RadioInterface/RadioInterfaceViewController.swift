//
//  ViewController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 20/06/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

protocol DeviceRotationHandler: class {
    func handleLandscapeRotation(isLandscape: Bool)
}

class RadioInterfaceViewController: UIViewController {

    weak var deviceRotationHandler: DeviceRotationHandler?

    private let styleGuide = StyleGuideFactory.current
    private let coreData = CoreDataManager()
    private var cancellable = Set<AnyCancellable>()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    var isLandscape: Bool {
        get {
            return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isLandscape
                : UIWindow().windowScene?.interfaceOrientation.isLandscape == true
        }
    }

    private lazy var radioInterfaceCollectionView = RadioInterfaceCollectionView(interfaceController: self)

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceRotationHandler?.handleLandscapeRotation(isLandscape: isLandscape)
        radioInterfaceCollectionView.updateCellAmount()
        addSubViews()
        setupUI()
    }

    override func viewWillLayoutSubviews() {
        radioInterfaceCollectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        radioInterfaceCollectionView.savedRadioStations = coreData.fetchData()
    }

    //MARK: - UI
    private func setupUI() {
        view.backgroundColor = styleGuide.colors.backgroundColor
        radioInterfaceCollectionView.pinToEdgesWithSafeArea(constant: 0)
    }

    private func addSubViews() {
        view.addSubview(radioInterfaceCollectionView)
    }
}

extension RadioInterfaceViewController {
    // MARK: - DeviceRotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewDidLayoutSubviews()
        deviceRotationHandler?.handleLandscapeRotation(isLandscape: isLandscape)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        radioInterfaceCollectionView.reloadData()
    }
}

extension RadioInterfaceViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard let savedStations = radioInterfaceCollectionView.savedRadioStations else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if !savedStations.isEmpty {
            let alert = AlertManager.shared.clearInterfaceAlert {
                self.clearInterface()
            }
            show(alert, sender: self)
        }
    }

    private func clearInterface() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        radioInterfaceCollectionView.savedRadioStations?.removeAll()
        coreData.deleteData()
        radioInterfaceCollectionView.reloadData()
    }
}



