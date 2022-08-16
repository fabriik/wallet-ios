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
    
    var itemId: String?
    
    var from: Amount?
    var to: Amount?
    
    var fromFee: TransferFeeBasis?
    var toFee: TransferFeeBasis?
    var fromFeeEth: Decimal?
    var toFeeEth: Decimal?
    
    var quote: Quote?
    var fromRate: Decimal?
    var toRate: Decimal?
    
    var fromCurrency: Currency?
    var toCurrency: Currency?
    
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
    
    var fromFeeAmount: Amount? {
        if let value = fromFeeEth,
           let currency = currencies.first(where: { $0.code == "ETH" }) {
            return .init(tokenString: value.description, currency: currency)
        } else if let value = fromFee?.fee,
                  let currency = currencies.first(where: { $0.code == value.currency.code.uppercased() }) {
            return .init(cryptoAmount: value, currency: currency)
        }
        return nil
    }
    
    var toFeeAmount: Amount? {
        if let value = toFeeEth,
           let currency = currencies.first(where: { $0.code == "ETH" }) {
            return .init(tokenString: value.description, currency: currency)
        } else if let value = toFee?.fee,
                  let currency = currencies.first(where: { $0.code == value.currency.code.uppercased() }) {
            return .init(cryptoAmount: value, currency: currency)
        }
        return nil
    }
    
    var swapPair: String {
        let from = fromCurrency?.code ?? "</>"
        let to = toCurrency?.code ?? "</>"
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
