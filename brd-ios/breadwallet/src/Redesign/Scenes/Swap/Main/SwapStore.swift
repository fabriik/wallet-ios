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
    var supportedCurrencies: [SupportedCurrency]?
    
    var sendingFee: TransferFeeBasis?
    var receivingFee: TransferFeeBasis?
    
    var fromFiatAmount: Decimal?
    var fromCryptoAmount: Decimal?
    var toFiatAmount: Decimal?
    var toCryptoAmount: Decimal?
    
    var fromBaseFiatFee: Decimal?
    var fromBaseCryptoFee: Decimal?
    
    var fromTermFiatFee: Decimal?
    var fromTermCryptoFee: Decimal?
    
    var minMaxToggleValue: FESegmentControl.Values?
    var defaultCurrencyCode: String?
    
    var baseCurrencies: [String] = []
    var termCurrencies: [String] = []
    var baseAndTermCurrencies: [[String]] = []
    
    var selectedBaseCurrency: String? = "BSV"
    var selectedTermCurrency: String? = "BCHdoes"
    
    var swap: Swap?
    
    var currencies: [Currency] = []
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    var side: Swap.Side {
        if supportedCurrencies?.first(where: { $0.baseCurrency == selectedBaseCurrency }) != nil {
            return .sell
        } else {
            return .buy
        }
    }
    
    // MARK: - Aditional helpers
    var quoteTerm: String? {
        let item = supportedCurrencies?.first(where: { currency in
            if currency.baseCurrency == selectedBaseCurrency,
               currency.termCurrency == selectedTermCurrency {
                return true
            } else if currency.termCurrency == selectedBaseCurrency,
                      currency.baseCurrency == selectedTermCurrency {
                return true
            } else {
                return false
            }
        })
        
        return item?.name
    }
}
