//
//  BuyStore.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit
import WalletKit

class BuyStore: NSObject, BaseDataStore, BuyDataStore {
    // MARK: - BuyDataStore
    var itemId: String?
    
    var from: Decimal?
    var to: Decimal?
    var toCurrency: Currency?
    
    override init() {
        super.init()
        if let currency = Store.state.currencies.first(where: { $0.code.lowercased() == C.BTC.lowercased() }) {
            toCurrency = currency
        } else {
            toCurrency = Store.state.currencies.first
        }
    }
    
    var feeAmount: Amount? {
        guard let value = quote?.toFee,
              let currency = currencies.first(where: { $0.code == value.currency.uppercased() }) else {
            return nil
        }
        return .init(amount: value.fee, currency: currency, exchangeRate: quote?.exchangeRate)
    }
    
    var fromCurrency: String? = Store.state.defaultCurrencyCode.lowercased()
    
    var toAmount: Amount?
    
    var isInputFiat = false
    var paymentCard: PaymentCard?
    var allPaymentCards: [PaymentCard]?
    
    var quote: Quote?
    
    var currencies: [Currency] = Store.state.currencies
    var supportedCurrencies: [SupportedCurrency]?
    
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    var autoSelectDefaultPaymentMethod = true
    
    // MARK: - Aditional helpers
    
    var isFormValid: Bool {
        guard let amount = toAmount,
              amount.tokenValue > 0,
              paymentCard != nil,
              feeAmount != nil
        else {
            return false
        }
        return true
    }
}
