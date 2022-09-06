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
    var toCurrency: Currency? = Store.state.currencies.first(where: { $0.code.lowercased() == "btc" })
    
    var feeAmount: Amount? {
        guard let value = quote?.toFee,
              let fee = ExchangeFormatter.crypto.string(for: value.fee),
              let currency = currencies.first(where: { $0.code == value.currency.uppercased() }) else {
            return nil
        }
        return .init(tokenString: fee, currency: currency)
    }
    
    var fromCurrency: String? = Store.state.defaultCurrencyCode.lowercased()
    
    var toAmount: Amount? {
        guard let toCurrency = toCurrency else { return nil }
        guard let to = to else { return.zero(toCurrency) }
        
        return .init(amount: to, currency: toCurrency, exchangeRate: 1 / (quote?.exchangeRate ?? 1))
    }
    
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

extension Amount {
    init(amount: Decimal, currency: Currency, exchangeRate: Decimal? = nil, decimals: Int = 9) {
        let formatter = ExchangeFormatter.crypto
        let amountString = formatter.string(for: amount) ?? ""
        
        guard let exchangeRate = exchangeRate,
              decimals > 0
        else {
            self = .init(tokenString: amountString, currency: currency)
            return
        }
        
        let rate = Rate(code: currency.code,
                        name: currency.name,
                        rate: exchangeRate.doubleValue,
                        reciprocalCode: "")
        let value = Amount(tokenString: amountString, currency: currency, rate: rate)
        guard value.tokenValue > 0 else {
            self = .init(amount: amount, currency: currency, exchangeRate: exchangeRate, decimals: decimals - 1)
            return
        }
        self = value
    }
    
    init(fiat: Decimal, currency: Currency, exchangeRate: Decimal? = nil, decimals: Int = 9) {
        let formatter = ExchangeFormatter.fiat
        let amountString = formatter.string(for: fiat) ?? ""
        
        guard let exchangeRate = exchangeRate,
              decimals > 0
        else {
            self = .zero(currency)
            return
        }
        
        let rate = Rate(code: currency.code,
                        name: currency.name,
                        rate: exchangeRate.doubleValue,
                        reciprocalCode: "")
        guard let value = Amount(fiatString: amountString, currency: currency, rate: rate),
              value.tokenValue > 0 else {
            self = .init(fiat: fiat, currency: currency, exchangeRate: exchangeRate, decimals: decimals - 1)
            return
        }
        self = value
    }
}
