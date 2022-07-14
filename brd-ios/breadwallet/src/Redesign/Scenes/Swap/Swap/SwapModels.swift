//
//  SwapModels.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum SwapModels {
    typealias Item = (baseRate: Decimal,
                      termRate: Decimal,
                      rateTimeStamp: Double,
                      minMaxToggleValue: FESegmentControl.Values?)
    
    enum Sections: Sectionable {
        case rateAndTimer
        case swapCard
        case amountSegment
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct SwitchPlaces {
        struct ViewAction {}
    }
    
    struct Amounts {
        struct ViewAction {
            var fromFiatAmount: String?
            var fromCryptoAmount: String?
            var toFiatAmount: String?
            var toCryptoAmount: String?
            var minMaxToggleValue: FESegmentControl.Values?
        }
        
        struct ActionResponse {
            var fromFiatAmount: Decimal?
            var fromFiatAmountString: String?
            var fromCryptoAmount: Decimal?
            var fromCryptoAmountString: String?
            
            var toFiatAmount: Decimal?
            var toFiatAmountString: String?
            var toCryptoAmount: Decimal?
            var toCryptoAmountString: String?
            
            var fromBaseFiatFee: Double?
            var fromBaseCryptoFee: Double?
            
            var fromTermFiatFee: Double?
            var fromTermCryptoFee: Double?
            
            var baseCurrency: String?
            var baseCurrencyIcon: UIImage?
            var termCurrency: String?
            var termCurrencyIcon: UIImage?
            
            var minMaxToggleValue: FESegmentControl.Values?
            var baseBalance: Amount
        }
        
        struct ResponseDisplay {
            var amounts: MainSwapViewModel
            var rate: ExchangeRateViewModel
            var minMaxToggleValue: SegmentControlViewModel
            var shouldEnableConfirm: Bool
        }
    }
    
    struct SelectedAsset {
        struct ViewAction {
            var name: String?
        }
    }
}
