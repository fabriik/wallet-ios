//
//  SwapDetailsModels.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

enum SwapDetailsModels {
   // SwapDetails
    typealias Item = SwapDetails
    
    enum Section: Sectionable {
        case header
        case order
        case fromCurrency
        case image
        case toCurrency
        case timestamp
        case transactionFrom
        case transactionTo
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
}
