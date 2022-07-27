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
    
    var minMaxToggleValue: FESegmentControl.Values?
    var defaultCurrencyCode: String?
    
    var baseCurrencies: [String] = []
    var termCurrencies: [String] = []
    var baseAndTermCurrencies: [[String]] = []
    
    var swap: Swap?
    
    var currencies: [Currency] = []
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    var side: Swap.Side {
        if supportedCurrencies?.first(where: { $0.baseCurrency == fromCurrency?.code }) != nil {
            return .sell
        } else {
            return .buy
        }
    }
    
    // MARK: - Aditional helpers
    var quoteTerm: String? {
        let item = supportedCurrencies?.first(where: { currency in
            if currency.baseCurrency == fromCurrency?.code,
               currency.termCurrency == toCurrency?.code {
                return true
            } else if currency.termCurrency == fromCurrency?.code,
                      currency.baseCurrency == toCurrency?.code {
                return true
            } else {
                return false
            }
        })
        
        return item?.name
    }
    
    var fromFeeAmount: Amount? {
        guard let fee = fromFee?.fee,
              let currency = fromCurrency
        else { return nil }

        return Amount(cryptoAmount: fee, currency: currency)
    }
    
    var toFeeAmount: Amount? {
        guard let fee = toFee?.fee,
              let currency = toCurrency
        else { return nil }

        return Amount(cryptoAmount: fee, currency: currency)
    }
}
