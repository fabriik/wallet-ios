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
    /// Param 1&2 -> currency, param 3 balance
    case overDailyLimit
    case overLifetimeLimit
    case overExchangeLimit
    case pinConfirmation
    case notPermitted
    
    var errorMessage: String {
        switch self {
        case .tooLow(let amount, let currency):
            return String(format: "The amount is lower than the buy minimum of %.1f %@.",
                          amount.doubleValue,
                          currency)
            
        case .tooHigh(let amount, let currency):
            return String(format: "The amount is higher than the buy maximum of %.2f %@ per day.",
                          amount.doubleValue,
                          currency)
            
        case .overDailyLimit:
            return "You have reached your swap limit of 1,000 USD a day. Please upgrade your limits or change the amount for this swap."
            
        case .overLifetimeLimit:
            return "You have reached your lifetime swap limit of 10,000 USD. Please upgrade your limits or change the amount for this swap."
            
        case .noQuote(let pair):
            return "No quote for currency pair \(pair ?? "<missing>")."
            
        case .overExchangeLimit:
            return "Over exchange limit."
            
        case  .pinConfirmation:
            return "PIN Authentication failed"
            
        case .notPermitted:
            return "KYC 2 is needed before buys are enabled."
        }
    }
}
