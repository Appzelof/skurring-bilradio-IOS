//
//  IAP.swift
//  skurring
//
//  Created by Daniel Bornstedt on 01/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import StoreKit

final class IAPHelper: NSObject {
    static let shared = IAPHelper()

    private var products: [String: SKProduct] = [:]

    override init() {
        super.init()
        fetchProducts()
    }

    func fetchProducts() {
        let productIDs = Set([monthlySubscriptionID])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }

    func purchase(productID: String) {
        if let product = products[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }

    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { print("invalid \($0)")}
        response.products.forEach { products[$0.productIdentifier] = $0 }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error for request: \(error.localizedDescription)")
    }
}
