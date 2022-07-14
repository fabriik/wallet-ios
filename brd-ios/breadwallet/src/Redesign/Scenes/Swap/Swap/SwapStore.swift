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

class SwapStore: NSObject, BaseDataStore, SwapDataStore {
    // MARK: - SwapDataStore
    
    var itemId: String?
    
    var fromFiatAmount: Decimal?
    var fromCryptoAmount: Decimal?
    var toFiatAmount: Decimal?
    var toCryptoAmount: Decimal?
    
    var fromBaseFiatFee: Double?
    var fromBaseCryptoFee: Double?
    
    var fromTermFiatFee: Double?
    var fromTermCryptoFee: Double?
    
    var minMaxToggleValue: FESegmentControl.Values?
    var defaultCurrencyCode: String?
    
    var baseCurrencies: [String] = []
    var termCurrencies: [String] = []
    var baseAndTermCurrencies: [[String]] = []
    
    var selectedBaseCurrency: String?
    var selectedTermCurrency: String?
    
    var currencies: [Currency] = []
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
    
    // MARK: - Aditional helpers
}
