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
    case noQuote(from: String?, to: String?)
    /// Param 1: amount, param 2 currency symbol
    case tooLow(amount: Decimal, currency: String)
    /// Param 1: amount, param 2 currency symbol
    case tooHigh(amount: Decimal, currency: String)
    /// Param 1&2 -> currency, param 3 balance
    case balanceTooLow(balance: Decimal, currency: String)
    case overDailyLimit
    case overLifetimeLimit
    case overDailyLimitLevel2
    case notEnouthEthForFee
    // Unoficial errors
    case noFees
    case networkFee
    case overExchangeLimit
    case pinConfirmation
    case failed(error: Error?)
    case pendingSwap
    case selectAssets
    
    // TODO: localize
    var errorMessage: String {
        switch self {
        case .balanceTooLow(let balance, let currency):
            return L10n.ErrorMessages.balanceToLow(currency, currency, ExchangeFormatter.crypto.string(for: balance) ?? "0.00"))
            
        case .tooLow(let amount, let currency):
            return L10n.ErrorMessages.amountToLow(Int(amount), currency)
            
        case .tooHigh(let amount, let currency):
            return L10n.ErrorMessages.swapAmountToHigh(amount, currency)
            
        case .overDailyLimit:
            return L10n.ErrorMessages.overDailyLimit
            
        case .overLifetimeLimit:
            return L10n.ErrorMessages.overLifetimeLimit
            
        case .overDailyLimitLevel2:
            return L10n.ErrorMessages.overLifetimeLimitLevel2
            
        case .noFees:
            return L10n.ErrorMessages.noFees
            
        case .networkFee:
            return L10n.ErrorMessages.networkFee
            
        case .noQuote(let from, let to):
            let from = from ?? "/"
            let to = to ?? "/|"
            return L10n.ErrorMessages.noQuoteForPair(from, to)
            
        case .overExchangeLimit:
            return L10n.ErrorMessages.overExchangeLimit
            
        case  .pinConfirmation:
            return L10n.ErrorMessages.pinConfirmationFailed
            
        case .notEnouthEthForFee:
            return L10n.ErrorMessages.notEnoughEthForFee
            
        case .failed(let error):
            return L10n.ErrorMessages.exchangeFailed(error?.localizedDescription)
            
        case .pendingSwap:
            return L10n.ErrorMessages.pendingExchange
            
        case .selectAssets:
            return L10n.ErrorMessages.selectAssets
        }
    }
}
