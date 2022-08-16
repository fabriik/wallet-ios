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
    
    var from: Decimal?
    var to: Decimal?
    var toCurrency: Currency? = Store.state.currencies.first(where: { $0.code.lowercased() == "btc" })
    var fromCurrency: String? = Store.state.defaultCurrencyCode.lowercased()
    
    var toAmount: Amount? {
        guard let toCurrency = toCurrency else { return nil }
        guard let to = to else { return.zero(toCurrency) }
        
        return Amount(tokenString: to.description, currency: toCurrency)
    }
    
    var paymentCard: PaymentCard?
    var allPaymentCards: [PaymentCard]?
    
    var rate: Decimal?

    // MARK: - Aditional helpers
}
