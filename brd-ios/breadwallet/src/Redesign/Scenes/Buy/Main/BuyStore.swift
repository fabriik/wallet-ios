//
//  BuyStore.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

class BuyStore: NSObject, BaseDataStore, BuyDataStore {
    // MARK: - BuyDataStore
    var itemId: String?
    
    var from: Amount?
    var fromCurrency: Currency? = Store.state.currencies.first(where: { $0.code.lowercased() == "btc" })
    var toCurrency: String? = Store.state.defaultCurrencyCode.lowercased()
    var paymentCard: PaymentCard?
    var allPaymentCards: [PaymentCard]?
    
    var rate: Decimal?

    // MARK: - Aditional helpers
}
