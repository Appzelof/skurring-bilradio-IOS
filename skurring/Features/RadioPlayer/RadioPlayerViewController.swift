//
//  RadioStations.swift
//  skurring
//
//  Created by Daniel Bornstedt on 26/07/2019.
//  Copyright © 2019 Daniel Bornstedt. All rieghts reserved.
//

import Foundation
import UIKit
import MarqueeLabel

protocol RadioPlayerViewControllerHandler: class {
    func playerViewControllerDidDismiss()
    func playerViewControllerDidShow()
}

final class RadioPlayerViewController: UIViewController {
    
    private let styleGuide = StyleGuideFactory.current

    weak var radioPlayerViewControllerDelegate: RadioPlayerViewControllerHandler?

    private var radioPlayer: RadioPlayer? {
        didSet {
            self.radioPlayer?.metaDataHandlerDelegate = self
        }
    }

    private lazy var radioStations: [RadioObject] = []

    private var currentIndex = 0
    private let isLandscape = UIDevice.current.orientation.isLandscape

    private let speedometer = SpeedometerView()
    private let featureStack = FeatureStackView()
    private var videoPlayerView = VideoPlayer()
    private let weatherView = WeatherView()
    private let radioImageView = UIImageView()
    private let radioNameTextLabel = UILabel()
    private let metaDataTextLabel = MarqueeLabel(
        frame: .zero,
        duration: 8,
        fadeLength: 30
    )
    
    private var hiResLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi-Res \n Audio"
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()

    init(for index: Int, radioStations: [RadioObject]) {
        super.init(nibName: nil, bundle: nil)
        self.currentIndex = index
        self.radioStations = radioStations

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecameActive),
            name: .applicationDidBecomeActive, object: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        radioPlayer = nil

    }
    
    override func viewDidLoad() {
        addSubViews()
        addDefaultConstraints()
        setupUIPrerequisits()
        addGestures()
        handleLandscapeRotation(isLandscape: isLandscape)
        videoPlayerView.videoAnimatorListener = self

        setRadioData { [weak self] radioStation in
            guard let self = self else { return }

            let isHQAudio = UserDefaults().bool(forKey: ConstantHelper.streamQualityHigh)
            self.hiResLabel.isHidden = !isHQAudio || radioStation.radioHQURL.isEmpty

            let radioURL = isHQAudio
                && !radioStation.radioHQURL.isEmpty
                ? radioStation.radioHQURL
                : radioStation.radioURL

            self.radioPlayer = RadioPlayer(
                radioStream: radioURL,
                channelName: radioStation.name
            )
            
            self.updateUIWithRadioStationData(with: radioStation)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.videoPlayerView.play()
            self.radioPlayer?.play()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        radioPlayerViewControllerDelegate?.playerViewControllerDidDismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        radioPlayerViewControllerDelegate?.playerViewControllerDidShow()
        speedometer.isHidden = !UserDefaults().bool(forKey: ConstantHelper.speedometer)
        featureStack.isHidden = !UserDefaults().bool(forKey: ConstantHelper.airPlay)
        radioNameTextLabel.isHidden = !UserDefaults().bool(forKey: ConstantHelper.radioChannel)
        metaDataTextLabel.isHidden = !UserDefaults().bool(forKey: ConstantHelper.metadataInfo)
        videoPlayerView.isHidden = !UserDefaults().bool(forKey: ConstantHelper.volumeIndicator)
        weatherView.isHidden = !UserDefaults().bool(forKey: ConstantHelper.weather)

        if !speedometer.isHidden || !weatherView.isHidden {
            LocationManager.shared.startUpdatingLocation()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let islandScape = UIDevice.current.orientation.isLandscape
        handleLandscapeRotation(isLandscape: islandScape)
    }


    private func updateUIWithRadioStationData(with station: RadioObject) {
        DispatchQueue.main.async {
            self.radioImageView.image = station.image
            self.radioNameTextLabel.text = station.name
        }
    }
    
    private func setupUIPrerequisits() {
        view.backgroundColor = styleGuide.colors.buttonBackgroundColor
        metaDataTextLabel.textColor = .white
        radioNameTextLabel.textColor = .white

        metaDataTextLabel.alpha = 0
        radioNameTextLabel.alpha = 0

        radioImageView.contentMode = .scaleAspectFit
        metaDataTextLabel.textAlignment = .center

        metaDataTextLabel.font = UIFont.systemFont(ofSize: 20)
        radioNameTextLabel.font = UIFont.systemFont(ofSize: 20)

        radioNameTextLabel.textAlignment = .center
    }

    private func addSubViews() {
        let subViews = [
            radioImageView,
            videoPlayerView,
            metaDataTextLabel,
            radioNameTextLabel,
            featureStack,
            speedometer,
            weatherView,
            hiResLabel
        ]

        subViews.forEach(view.addSubview)
    }

    private func setRadioData(completion: @escaping (RadioObject) -> Void) {
        for radioStation in radioStations {
            if radioStation.buttonTag == currentIndex {
                DispatchQueue.main.async {
                    completion(radioStation)
                }
            }
        }
    }

    private func addGestures() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissVC)
        )
        view.addGestureRecognizer(gesture)
    }

    @objc
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    private func applicationDidBecameActive(notification: Notification) {
        radioPlayer?.play()
    }

    private func handleLandscapeRotation(isLandscape: Bool) {
        deactivateOrientationConstraints()
        if !isLandscape {
            featureStack.updateAxis(orientation: .portrait)
            addPortraitConstraints()
        } else {
            featureStack.updateAxis(orientation: .landscape)
            addLandscapeConstraints()
        }
    }

    private func addDefaultConstraints() {
        radioImageView.translatesAutoresizingMaskIntoConstraints = false
        radioNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        metaDataTextLabel.translatesAutoresizingMaskIntoConstraints = false
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        speedometer.translatesAutoresizingMaskIntoConstraints = false
        hiResLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            
            [
                hiResLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
                hiResLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),

                radioImageView.heightAnchor.constraint(equalToConstant: 150),
                radioImageView.widthAnchor.constraint(equalToConstant: 200),
                radioImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                radioImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                videoPlayerView.widthAnchor.constraint(equalToConstant: 160),
                videoPlayerView.heightAnchor.constraint(equalToConstant: 55),
                videoPlayerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                videoPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                radioNameTextLabel.heightAnchor.constraint(equalToConstant: 30),
                radioNameTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                radioNameTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                radioNameTextLabel.bottomAnchor.constraint(equalTo: metaDataTextLabel.topAnchor),

                metaDataTextLabel.heightAnchor.constraint(equalToConstant: 30),
                metaDataTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                metaDataTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                metaDataTextLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }

    private func addPortraitConstraints() {
        portraitConstraints =

            [
                speedometer.heightAnchor.constraint(equalToConstant: 100),
                speedometer.widthAnchor.constraint(equalToConstant: 120),
                speedometer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                speedometer.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                featureStack.widthAnchor.constraint(equalToConstant: 270),
                featureStack.heightAnchor.constraint(equalToConstant: 40),
                featureStack.bottomAnchor.constraint(equalTo: radioNameTextLabel.topAnchor, constant: -20),
                featureStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                weatherView.heightAnchor.constraint(equalToConstant: 100),
                weatherView.widthAnchor.constraint(equalToConstant: 100),
                weatherView.topAnchor.constraint(equalTo: speedometer.bottomAnchor, constant: 40),
                weatherView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ]

        NSLayoutConstraint.activate(portraitConstraints)


    }

    private func addLandscapeConstraints() {
        landscapeConstraints =

            [
                speedometer.heightAnchor.constraint(equalToConstant: 100),
                speedometer.widthAnchor.constraint(equalToConstant: 120),
                speedometer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                speedometer.bottomAnchor.constraint(equalTo: radioNameTextLabel.topAnchor),

                featureStack.widthAnchor.constraint(equalToConstant: 30),
                featureStack.heightAnchor.constraint(equalToConstant: 250),
                featureStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

                weatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
                weatherView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                weatherView.heightAnchor.constraint(equalToConstant: 100),
                weatherView.widthAnchor.constraint(equalToConstant: 100),
            ]

        NSLayoutConstraint.activate(landscapeConstraints)
    }

    private func deactivateOrientationConstraints() {
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
    }
}

extension RadioPlayerViewController: MetaDataHandlerDelegate, VideoAnimationListener {
    func fetchMetaData(metaData: String?) {
        DispatchQueue.main.async {
            self.metaDataTextLabel.text = metaData
        }
    }

    func videoDidStopAnimating() {
        UIView.animate(withDuration: 3) {
            self.radioNameTextLabel.alpha = 1
            self.metaDataTextLabel.alpha = 1
        }
    }
}
