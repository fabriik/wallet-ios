// 
//  BuyErrors.swift
//  breadwallet
//
//  Created by Rok on 19/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum BuyErrors: FEError {
    case noQuote(pair: String?)
    /// Param 1: amount, param 2 currency symbol
    case tooLow(amount: Decimal, currency: String)
    /// Param 1: amount, param 2 currency symbol
    case tooHigh(amount: Decimal, currency: String)
    case pinConfirmation
    case authorizationFailed
    
    var errorMessage: String {
        switch self {
        case .tooLow(let amount, let currency):
            return String(format: "The amount is lower than the minimum of $%.0f %@. Please enter a higher amount.",
                          amount.doubleValue,
                          currency)
            
        case .tooHigh(let amount, let currency):
            return String(format: "The amount is higher than your daily limit of $%.0f %@. Please enter a lower amount.",
                          amount.doubleValue,
                          currency)
            
        case .noQuote(let pair):
            return "No quote for currency pair \(pair ?? "<missing>")."
            
        case  .pinConfirmation:
            return "PIN Authentication failed"
            
        case .authorizationFailed:
            return "Card authorization failed. Please contact your credit card issuer/bank or try another card."
        }
    }
}
