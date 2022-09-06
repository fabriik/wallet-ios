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
        
        return amountFrom(decimal: to, currency: toCurrency)
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
    
    func amountFrom(decimal: Decimal?, currency: Currency, spaces: Int = 9) -> Amount {
        guard let amount = decimal, spaces > 0 else { return .zero(currency) }
        
        let formatter = ExchangeFormatter.current
        formatter.maximumFractionDigits = spaces
        
        let amountString = formatter.string(for: amount) ?? ""
        let rate = Rate(code: currency.code,
                        name: currency.name,
                        rate: 1 / (quote?.exchangeRate.doubleValue ?? 1),
                        reciprocalCode: "")
        let value = Amount(tokenString: amountString, currency: currency, rate: rate)
        
        guard value.tokenValue != 0 else {
            return amountFrom(decimal: decimal, currency: currency, spaces: spaces - 1)
        }
        
        return value
    }
    
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
    
    // TODO: extract (it being used in swap and buy)
    func address(for currency: Currency?) -> String? {
        guard let currency = currency else {
            return nil
        }

        let addressScheme: AddressScheme
        if currency.isBitcoin {
            addressScheme = UserDefaults.hasOptedInSegwit ? .btcSegwit : .btcLegacy
        } else {
            addressScheme = currency.network.defaultAddressScheme
        }
        return currency.wallet?.receiveAddress(for: addressScheme)
    }
}
