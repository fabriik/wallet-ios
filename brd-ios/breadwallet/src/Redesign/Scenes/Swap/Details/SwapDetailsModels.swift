//
//  SwapDetailsModels.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

enum SwapDetailsModels {
    enum Section: Sectionable {
        case header
        case order
        case fromCurrency
        case toCurrency
        case transactionID
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
}
