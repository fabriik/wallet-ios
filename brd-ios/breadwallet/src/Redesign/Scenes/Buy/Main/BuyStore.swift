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
    var toFee: TransferFeeBasis?
    
    var ethFee: Decimal?
    var transferFee: TransferFeeBasis?
    
    var networkFee: Amount? {
        if let value = ethFee,
           let currency = currencies.first(where: { $0.code == "ETH" }) {
            return .init(tokenString: value.description, currency: currency)
        } else if let value = toFee,
                  let currency = currencies.first(where: { $0.code == value.currency.code.uppercased() }) {
            return .init(cryptoAmount: value.fee, currency: currency)
        }
        return nil
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
    
    // MARK: - Aditional helpers
    func amountFrom(decimal: Decimal?, currency: Currency, spaces: Int = 9) -> Amount {
        guard let amount = decimal, spaces > 0 else { return .zero(currency) }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = spaces
        
        let amountString = formatter.string(for: amount) ?? ""
        let rate = Rate(code: currency.code,
                        name: currency.code,
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
              paymentCard != nil else {
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
