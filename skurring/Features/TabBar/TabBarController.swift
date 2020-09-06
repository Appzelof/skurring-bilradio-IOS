//
//  TabbarController.swift
//  skurring
//
//  Created by Daniel Bornstedt on 15/07/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    private let styleGuide = StyleGuideFactory.current
    private let appareance = UITabBarAppearance()
    
    override func viewDidLoad() {
        setupUI()

        let radioInterfaceVC = RadioInterfaceViewController()
        radioInterfaceVC.tabBarItem = UITabBarItem(
            title: ConstantHelper.radioTab,
            image: UIImage(named: "radio"),
            selectedImage: UIImage(named: "radio")
        )

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: ConstantHelper.settingsTab,
            image: UIImage(named: "settings"),
            selectedImage: UIImage(named: "settings")
        )

        let IAPVC = IAPViewController()
        IAPVC.tabBarItem = UITabBarItem(
            title: "Premium",
            image: nil,
            selectedImage: nil)

        let viewControllerList = [radioInterfaceVC, settingsVC, IAPVC]

        viewControllers = viewControllerList
    }

    func setupUI(){
        tabBar.backgroundColor = styleGuide.colors.buttonBackgroundColor
        tabBar.isTranslucent = false
        tabBar.tintColor = styleGuide.colors.skurringTheme
    }
}

