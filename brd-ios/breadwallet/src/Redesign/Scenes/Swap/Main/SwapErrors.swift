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
    /// Param 1: amount, param 2 currency symbol
    case tooLow(amount: Decimal, currency: String)
    /// Param 1: amount, param 2 currency symbol
    case tooHigh(amount: Decimal, currency: String)
    /// Param 1&2 -> currency, param 3 balance
    case balanceTooLow(balance: Decimal, currency: String)
    case overDailyLimit
    case overLifetimeLimit
    case overDailyLimitLevel2
    // Unoficial errors
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
            
        case .tooLow(let amount, let currency):
            return String(format: "The amount is lower than the minimum of %.1f %@. Please enter a higher amount.",
                          amount.doubleValue,
                          currency)
            
        case .tooHigh(let amount, let currency):
            return String(format: "The amount is higher than the swap maximum of %.2f %@.",
                          amount.doubleValue,
                          currency)
            
        case .overDailyLimit:
            return "The amount is higher than your daily limit of $1,000 USD. Please upgrade your account or enter a lower amount."
            
        case .overLifetimeLimit:
            return "The amount is higher than your lifetime limit of $10,000 USD. Please upgrade your account or enter a lower amount."
            
        case .overDailyLimitLevel2:
            return "The amount is higher than your daily limit of $10,000 USD. Please enter a lower amount."
            
        case .noFees:
            return "Failed to fetch network fees. Please try again later."
            
        case .networkFee:
            return "This swap doesn't cover the included network fee. Please add more funds to your wallet or change the amount you're swapping."
            
        case .noQuote(let pair):
            return "No quote for currency pair \(pair ?? "<missing>")."
            
        case .overExchangeLimit:
            return "Over exchange limit."
            
        case  .pinConfirmation:
            return "PIN Authentication failed"
            
        case .notEnouthEthForFee(let fee):
            return "ERC-20 tokens require ETH network fees. Please make sure you have at least \(ExchangeFormatter.crypto.string(for: fee)) ETH in your wallet."
            
        case .failed(let error):
            return "Swap failed. Reason: \(error?.localizedDescription ?? "unknown")"
            
        case .pendingSwap:
            return "A maximum of one swap can be active for a currency at a time."
        }
    }
}
