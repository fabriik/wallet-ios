// 
//  Amount+Inits.swift
//  breadwallet
//
//  Created by Rok on 06/09/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

extension Amount {
    init(amount: Decimal, currency: Currency, exchangeRate: Decimal? = nil, decimals: Int = 16) {
        let formatter = ExchangeFormatter.current
        let amountString = formatter.string(for: amount) ?? ""
        
        guard let exchangeRate = exchangeRate,
              decimals >= 0
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
    
    init(fiat: Decimal, currency: Currency, exchangeRate: Decimal? = nil, decimals: Int = 16) {
        let formatter = ExchangeFormatter.current
        let amountString = formatter.string(for: fiat) ?? ""
        
        guard let exchangeRate = exchangeRate,
              decimals >= 0
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
