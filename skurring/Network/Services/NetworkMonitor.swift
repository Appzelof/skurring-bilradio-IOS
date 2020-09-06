//
//  NetworkStatus.swift
//  skurring
//
//  Created by Daniel Bornstedt on 23/07/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import Network

final class NetworkMonitor {
    static var shared = NetworkMonitor()

    private var isMonitoring = false
    
    private var monitor: NWPathMonitor?

    private init() { monitor = NWPathMonitor() }

    deinit { stopMonitoring() }

    enum Connection: String {
        case wifi = "WIFI"
        case cellular = "CELLULAR"
        case noConnection = "NO CONNECTION"
    }
    
    func startMonitoring(connection: @escaping (Connection) -> Void) {
        guard let monitor = monitor else { return }
        if !isMonitoring {
            let dispatch = DispatchQueue.global(qos: .background)
            monitor.start(queue: dispatch)
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    switch true {
                    case monitor.currentPath.usesInterfaceType(.wifi):
                        connection(.wifi)
                    case monitor.currentPath.usesInterfaceType(.cellular):
                        connection(.cellular)
                    default: break
                    }
                } else {
                    connection(.noConnection)
                }
            }
            isMonitoring = true
        }
    }

    func stopMonitoring() {
        guard let monitor = monitor else { return }
        monitor.cancel()
        isMonitoring = false
    }
}



