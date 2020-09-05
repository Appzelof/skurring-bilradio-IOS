//
//  NetworkStatus.swift
//  skurring
//
//  Created by Daniel Bornstedt on 23/07/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import Network

class NetworkMonitor {
    static var shared = NetworkMonitor()

    private var isMonitoring = false
    private var monitor: NWPathMonitor?

    private init() { monitor = NWPathMonitor() }

    deinit { stopMonitoring() }
    
    func startMonitoring(connection: @escaping (String) -> Void) {
        guard let monitor = monitor else { return }
        if !isMonitoring {
            let dispatch = DispatchQueue.global(qos: .background)
            monitor.start(queue: dispatch)
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    switch true {
                    case monitor.currentPath.usesInterfaceType(.wifi):
                        connection("WIFI")
                    case monitor.currentPath.usesInterfaceType(.cellular):
                        connection("CELLULAR")
                    default: break
                    }
                } else {
                    connection("NO CONNECTION")
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

    func getConnectionStatus() -> NWPath? {
        if let monitor = monitor {
            return monitor.currentPath
        }
        return nil
    }
}



