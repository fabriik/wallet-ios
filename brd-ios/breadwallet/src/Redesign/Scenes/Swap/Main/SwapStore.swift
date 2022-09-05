//
//  SwapStore.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

class SwapStore: NSObject, BaseDataStore, SwapDataStore {
    // MARK: - SwapDataStore
    
    enum UpdateType {
        case fromFiat
        case fromCrypto
        case toFiat
        case toCrypto
    }
    
    var itemId: String?
    var updateType: UpdateType = .fromFiat
    
    var from: Amount?
    var to: Amount?
    
    var fromFee: TransferFeeBasis?
    
    var quote: Quote?
    var fromRate: Decimal?
    var toRate: Decimal?
    
    var supportedCurrencies: [SupportedCurrency]?
    
    var defaultCurrencyCode: String?
    
    var baseCurrencies: [String] = []
    var termCurrencies: [String] = []
    var baseAndTermCurrencies: [[String]] = []
    
    var swap: Swap?
    
    var currencies: [Currency] = []
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    var pin: String?
    var isKYCLevelTwo: Bool?
    
    // MARK: - Aditional helpers
    
    func amountFrom(decimal: Decimal?, currency: Currency, spaces: Int = 9) -> Amount {
        guard let amount = decimal, spaces > 0 else { return .zero(currency) }
        
        let formatter = ExchangeFormatter.current
        formatter.maximumFractionDigits = spaces
        
        let amountString = formatter.string(for: amount) ?? ""
        let value = Amount(tokenString: amountString, currency: currency)
        
        guard value.tokenValue != 0 else {
            return amountFrom(decimal: decimal, currency: currency, spaces: spaces - 1)
        }
        
        return value
    }
    
    var fromFeeAmount: Amount? {
        guard let value = fromFee,
              let currency = currencies.first(where: { $0.code == value.fee.currency.code.uppercased() }) else {
            return nil
        }
        return .init(cryptoAmount: value.fee, currency: currency)
    }
    
    var toFeeAmount: Amount? {
        guard let value = quote?.toFee,
              let currency = currencies.first(where: { $0.code == value.currency.uppercased() }) else {
            return nil
        }
        return .init(tokenString: value.fee.description, currency: currency)
    }
    
    var swapPair: String {
        let from = from?.currency.code ?? "</>"
        let to = to?.currency.code ?? "</>"
        return "\(from)-\(to)"
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
