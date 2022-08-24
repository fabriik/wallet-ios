// 
//  ExchangeFormatter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 12/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ExchangeFormatter {
    static var crypto: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: C.usLocaleCode)
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 8
        return formatter
    }
    
    static var fiat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: C.usLocaleCode)
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    static var current: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = .current
        return formatter
    }
}

extension String {
    func sanitize(inputFormat: NumberFormatter, expectedFormat: NumberFormatter) -> String {
        // remove grouping separators
        var sanitized = replacingOccurrences(of: inputFormat.currencyGroupingSeparator, with: "")
        sanitized = sanitized.replacingOccurrences(of: inputFormat.groupingSeparator, with: "")

        // replace decimal separators
        sanitized = sanitized.replacingOccurrences(of: inputFormat.currencyDecimalSeparator, with: expectedFormat.decimalSeparator)
        sanitized = sanitized.replacingOccurrences(of: inputFormat.decimalSeparator, with: expectedFormat.decimalSeparator)
        
        return sanitized
    }
    
    func cleanupFormatting() -> String {
        let sanitized = sanitize(inputFormat: ExchangeFormatter.current, expectedFormat: ExchangeFormatter.crypto)
        
        return sanitized
    }
}
