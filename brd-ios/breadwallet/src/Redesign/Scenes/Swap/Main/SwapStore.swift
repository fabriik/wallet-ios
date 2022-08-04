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
    
    // MARK: - Aditional helpers
    
    var fromFeeAmount: Amount? {
        guard let fee = fromFee?.fee,
              let currency = currencies.first(where: { $0.code == fee.currency.code.uppercased() })
        else { return nil }

        return Amount(cryptoAmount: fee, currency: currency)
    }
    
    var toFeeAmount: Amount? {
        guard let fee = toFee?.fee,
              let currency = currencies.first(where: { $0.code == fee.currency.code.uppercased() })
        else { return nil }

        return Amount(cryptoAmount: fee, currency: currency)
    }
    
    var swapPair: String {
        let from = fromCurrency?.code ?? "</>"
        let to = toCurrency?.code ?? "</>"
        return "\(from)-\(to)"
    }
}
