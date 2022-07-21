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
import WalletKit

enum SwapModels {
    typealias Item = Any?
    
    enum Sections: Sectionable {
        case rateAndTimer
        case swapCard
        case amountSegment
        case errors
        
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
            
            var fromBaseFiatFee: Decimal?
            var fromBaseCryptoFee: Decimal?
            
            var fromTermFiatFee: Decimal?
            var fromTermCryptoFee: Decimal?
            
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
        }
    }
    
    struct SelectedAsset {
        struct ViewAction {
            var from: String?
            var to: String?
        }
    }
    
    struct Assets {
        struct ViewAction {
            var from: Bool?
            var to: Bool?
        }
        
        struct ActionResponse {
            var from: [String]?
            var to: [String]?
        }
        
        struct ResponseDisplay {
            var from: [String]?
            var to: [String]?
        }
    }
    
    struct Rate {
        struct ViewAction {
        }
        
        struct ActionResponse {
            var baseCurrency: String?
            var termCurrency: String?
            var baseRate: Decimal
            var termRate: Decimal
            var rateTimeStamp: Double
        }
        
        struct ResponseDisplay {
            var rate: ExchangeRateViewModel
        }
    }
    
    struct Fee {
        struct ActionResponse {
            var from: Decimal?
            var to: Decimal?
        }
        
        struct ResponseDisplay {
            var from: String?
            var to: String?
        }
    }
    
    struct ShowConfirmDialog {
        struct ViewAction {}
        
        struct ActionResponse {
            var from: Decimal?
            var fromFiat: Decimal?
            var fromCurrency: String?
            var to: Decimal?
            var toFiat: Decimal?
            var toCurrency: String?
            var quote: Quote?
            var fromFee: Decimal?
            var fromFiatFee: Decimal?
            var toFee: Decimal?
            var toFiatFee: Decimal?
        }
        
        struct ResponseDisplay {
            var config: WrapperPopupConfiguration<SwapConfimationConfiguration>
            var viewModel: WrapperPopupViewModel<SwapConfirmationViewModel>
        }
    }
    
    struct Confirm {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {}
    }
}
