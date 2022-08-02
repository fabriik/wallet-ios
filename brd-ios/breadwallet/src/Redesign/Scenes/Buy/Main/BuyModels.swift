//
//  BuyModels.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

enum BuyModels {
    
    typealias Item = Amount?
    
    enum Sections: Sectionable {
        case rate
        case from
        case to
        case error
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Amounts {
        struct ViewAction {
            var fiatValue: String?
            var tokenValue: String?
        }
        
        struct ActionResponse {
            var amount: Amount?
        }
        
        struct ResponseDisplay {
            var cryptoModel: SwapCurrencyViewModel?
            var cardModel: CardSelectionViewModel?
        }
    }
    
    struct Rate {
        struct ViewAction {
            var from: String?
            var to: String?
        }
        
        struct ActionResponse {
            var from: String?
            var to: String?
            var rate: Decimal?
            var expires: Double?
        }
        
        typealias ResponseDisplay = ExchangeRateViewModel
    }
    
    struct Assets {
        struct ViewAction {
            var currency: String?
            var card: Any?
        }
    }
}
