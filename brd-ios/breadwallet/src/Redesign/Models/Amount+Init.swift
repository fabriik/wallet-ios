//
//  Amount+Init.swift
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
    init(amount: Decimal, isFiat: Bool = false, currency: Currency, exchangeRate: Decimal? = nil, decimals: Int = 16) {
        let formatter = ExchangeFormatter.current
        formatter.maximumFractionDigits = decimals
        
        let amountString = formatter.string(for: amount)?.usDecimalString(fromLocale: formatter.locale) ?? ""
        
        guard let exchangeRate = exchangeRate, decimals >= 0 else {
            let emptyRate = Rate.empty
            
            if isFiat, let fallbackAmount = Amount(fiatString: "0", currency: currency, rate: emptyRate) {
                self = Amount(fiatString: amountString, currency: currency, rate: emptyRate) ?? fallbackAmount
            } else {
                self = Amount(tokenString: amountString, currency: currency)
            }
            
            return
        }
        
        let rate = Rate(code: currency.code,
                        name: currency.name,
                        rate: exchangeRate.doubleValue,
                        reciprocalCode: "")
        
        let value: Amount?
        
        if isFiat {
            value = Amount(fiatString: amountString, currency: currency, rate: rate)
        } else {
            value = Amount(tokenString: amountString, currency: currency, rate: rate)
        }
        
        guard let value = value,
                  value.tokenValue != 0 else {
            self = .init(amount: amount, isFiat: isFiat, currency: currency, exchangeRate: exchangeRate, decimals: decimals - 1)
            return
        }
        self = value
    }
}
