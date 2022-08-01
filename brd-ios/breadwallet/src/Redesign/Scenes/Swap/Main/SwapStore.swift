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
    
    var pin: String?
    
    var side: Swap.Side {
        if pair?.baseCurrency == fromCurrency?.code {
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
    
    private var pair: SupportedCurrency? {
        return supportedCurrencies?.first(where: { $0.baseCurrency == fromCurrency?.code && $0.termCurrency == toCurrency?.code })
        ?? supportedCurrencies?.first(where: { $0.baseCurrency == toCurrency?.code && $0.termCurrency == fromCurrency?.code })
    }
    
    func exchangeRate(for currency: Currency?) -> Decimal {
        guard let pair = pair,
              let quote = quote else {
            return 0
        }
        
        if pair.baseCurrency == currency?.code {
            return quote.exchangeRate
        } else {
            return 1 / quote.exchangeRate
        }
    }
    
    var markup: Decimal {
        guard let pair = pair,
              let quote = quote else {
            return 0
        }
        
        if pair.baseCurrency == fromCurrency?.code {
            return quote.buyMarkup
        } else {
            return 1/quote.sellMarkup
        }
    }
    
}
