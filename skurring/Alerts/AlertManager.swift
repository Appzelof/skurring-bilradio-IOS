//
//  Alert.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

final class AlertManager {

    static let shared = AlertManager()

    private init() {}

    func noRadioStationSavedAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "No Radio Station Saved",
            message: "Please longpress a radio button to open channel selector",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "Got It", style: .cancel, handler: nil)
        alert.addAction(confirm)
        return alert
    }

    func clearInterfaceAlert(completion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "Clear interface?" ,
            message: "Clearing this interface will remove all saved radio stations",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            completion()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actions = [confirm, cancel]
        actions.forEach(alert.addAction)
        return alert
    }
}
