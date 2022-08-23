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
    case balanceTooLow(balance: Decimal, currency: String)
    case overDailyLimit
    case overLifetimeLimit
    // TODO: Unoficial errors
    case notEnouthEthForFee(fee: Decimal)
    case noFees
    case networkFee
    case overExchangeLimit
    case pinConfirmation
    case failed(error: Error?)
    case pendingSwap
    
    var errorMessage: String {
        switch self {
        case .balanceTooLow(let balance, let currency):
            return String(format: "You don't have enough %@ to complete this swap. Your current %@ balance is %@",
                          currency,
                          currency,
                          ExchangeFormatter.crypto.string(for: balance) ?? "0.00")
            
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
            return "This swap doesn't cover the included network fee. Please add more funds to your wallet or change the amount you're swapping."
            
        case .noQuote(let pair):
            return "No quote for currency pair \(pair ?? "<missing>")."
            
        case .overExchangeLimit:
            return "Over exchange limit."
            
        case  .pinConfirmation:
            return "PIN Authentication failed"
            
        case .notEnouthEthForFee(let fee):
            return "ERC-20 tokens require ETH network fees. Please make sure you have at least \(fee.description) ETH in your wallet."
            
        case .failed(let error):
            return "Swap failed. Reason: \(error?.localizedDescription ?? "unknown")"
            
        case .pendingSwap:
            return "A maximum of one swap can be active for a currency at a time."
        }
    }
}
