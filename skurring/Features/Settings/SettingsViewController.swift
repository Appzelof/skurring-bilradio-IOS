//
//  SettingsViewController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 08/12/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit


final class SettingsViewController: UIViewController {
    private let styleGuide = StyleGuideFactory.current
    
    private lazy var tableView = UITableView()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    private let settingList = [

        //Skurring basic features

            [ConstantHelper.speedometer,
             ConstantHelper.weather,
             ConstantHelper.radioChannel,
             ConstantHelper.metadataInfo,
             ConstantHelper.volumeIndicator
            ],

        //Skurring premium features

            [ConstantHelper.airPlay,
             ConstantHelper.streamQualityHigh,
             ConstantHelper.shakeToDelete,
             ConstantHelper.landscape]
        ]

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            SettingsTableViewCell.self,
            forCellReuseIdentifier: ConstantHelper.settingsCell
        )

        view.addSubview(tableView)
        addConstraints()
        updateUI()
    }

    private func addConstraints() {
        tableView.pinToEdgesWithSafeArea(constant: 10)
    }

    private func updateUI() {
        tableView.backgroundColor = .clear
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .black

        if section == 0 {
            label.text = ConstantHelper.basic
            label.textColor = StyleGuideFactory.current.colors.textColor
        } else {
            label.text = ConstantHelper.premium
            label.textColor = StyleGuideFactory.current.colors.orangeTheme
        }

        return label
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConstantHelper.settingsCell,
            for: indexPath) as? SettingsTableViewCell
            else { return UITableViewCell() }

        cell.updateUI(setting: settingList[indexPath.section][indexPath.row])

        return cell
    }
}

fileprivate final class SettingsTableViewCell: UITableViewCell {
    private let settingsSwitch = UISwitch()
    private var setting = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIPrerequisits()
        addConstraints()

        settingsSwitch.addTarget(
            self,
            action: #selector(saveSettings),
            for: .primaryActionTriggered
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(setting: String) {
        DispatchQueue.main.async {
            self.setting = setting
            self.textLabel?.text = setting
            self.textLabel?.textColor = .white
            self.settingsSwitch.setOn(
                UserDefaults().bool(forKey: setting),
                animated: false
            )
        }
    }

    func addConstraints() {
        settingsSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            settingsSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            settingsSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    private func setupUIPrerequisits() {
        contentView.addSubview(settingsSwitch)
        backgroundColor = .clear
        selectionStyle = .none
    }

    @objc
    private func saveSettings() {
        UserDefaults().set(settingsSwitch.isOn, forKey: setting)
        guard
            UserDefaults().bool(forKey: ConstantHelper.speedometer) ||
            UserDefaults().bool(forKey: ConstantHelper.weather)
        else {
            LocationManager.shared.stopUpdatingLocation()
            return
        }

        LocationManager.shared.startUpdatingLocation()
    }
}
