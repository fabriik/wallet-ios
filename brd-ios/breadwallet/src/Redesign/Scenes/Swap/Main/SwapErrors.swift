// 
//  SwapErrors.swift
//  breadwallet
//
//  Created by Rok on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum SwapErrors: FEError {
    case noQuote(pair: String?)
    case general
    /// Param 1: amount, param 2 currency symbol
    case tooLow(amount: Decimal, currency: String)
    /// Param 1: amount, param 2 currency symbol
    case tooHigh(amount: Decimal, currency: String)
    /// Param 1&2 -> currency, param 3 balance
    case balanceTooLow(amount: Decimal, balance: Decimal, currency: String)
    case overDailyLimit
    case overLifetimeLimit
    // TODO: unoficial error xD
    case notEnouthEthForFee(fee: Decimal)
    case noFees
    case networkFee
    case overExchangeLimit
    case pinConfirmation
    
    var errorMessage: String {
        switch self {
        case .balanceTooLow(let amount, let balance, let currency):
            return String(format: "You don't have enough %@ to complete this swap. Your need %.5f, but your balance is %.5f.",
                          currency,
                          amount.doubleValue,
                          balance.doubleValue)
            
        case .general:
            return "BSV network is experiencing network issues. Swapping assets is temporarily unavailable."
            
        case .tooLow(let amount, let currency):
            return String(format: "The amount is lower than the swap minimum of %.1f %@.",
                          amount.doubleValue,
                          currency)
            
        case .tooHigh(let amount, let currency):
            return String(format: "The amount is higher than the swap maximum of %.2f %@.",
                          amount.doubleValue,
                          currency)
            
        case .overDailyLimit:
            return "You have reached your swap limit of 1,000 USD a day. Please upgrade your limits or change the amount for this swap."
            
        case .overLifetimeLimit:
            return "You have reached your lifetime swap limit of 10,000 USD. Please upgrade your limits or change the amount for this swap."
            
        case .noFees:
            return "No network fees."
            
        case .networkFee:
            return "This swap doesn't cover the included network fee. Please add more funds to your ETH wallet or change the amount you're swapping."
            
        case .noQuote(let pair):
            return "No quote for currency pair \(pair ?? "<missing>")."
            
        case .overExchangeLimit:
            return "Over exchange limit."
            
        case  .pinConfirmation:
            return "PIN Authentication failed"
            
        case .notEnouthEthForFee(let fee):
            return "Not enouth ETH to pay for the network fee. Please deposit at least \(fee.description) ETH."
        }
    }
}
