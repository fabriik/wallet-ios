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
        
        return amountFrom(decimal: to, currency: toCurrency)
    }
    
    var paymentCard: PaymentCard?
    var allPaymentCards: [PaymentCard]?
    
    var quote: Quote?
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    // MARK: - Aditional helpers
    private func amountFrom(decimal: Decimal?, currency: Currency, spaces: Int = 9) -> Amount {
        guard let amount = decimal, spaces > 0 else { return .zero(currency) }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = spaces
        
        let amountString = formatter.string(for: amount) ?? ""
        let value = Amount(tokenString: amountString, currency: currency)
        
        guard value.tokenValue != 0 else {
            return amountFrom(decimal: decimal, currency: currency, spaces: spaces - 1)
        }
        return value
    }
    
    var isFormValid: Bool {
        guard let amount = toAmount,
              amount.tokenValue > 0,
              paymentCard != nil else {
            return false
        }
        return true
    }
}
