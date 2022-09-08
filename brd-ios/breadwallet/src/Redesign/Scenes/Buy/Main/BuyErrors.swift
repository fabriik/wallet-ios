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
    case noQuote(from: String?, to: String?)
    /// Param 1: amount, param 2 currency symbol
    case tooLow(amount: Decimal, currency: String)
    /// Param 1: amount, param 2 currency symbol
    case tooHigh(amount: Decimal, currency: String)
    case pinConfirmation
    case authorizationFailed
    
    // TODO: localize
    var errorMessage: String {
        switch self {
        case .tooLow(let amount, let currency):
            return L10n.ErrorMessages.amountToLow(Int(amount), currency)
            
        case .tooHigh(let amount, let currency):
            return L10n.ErrorMessages.amountToHigh(Int(amount), currency)
            
        case .noQuote(let from, let to):
            let from = from ?? "/"
            let to = to ?? "/"
            return L10n.ErrorMessages.noQuoteForPair(from, to)
            
        case  .pinConfirmation:
            return L10n.ErrorMessages.pinConfirmationFailed
            
        case .authorizationFailed:
            return L10n.ErrorMessages.authorizationFailed
        }
    }
}
