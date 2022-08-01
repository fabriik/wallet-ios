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
    typealias Item = (from: Currency?, to: Currency?, quote: Quote?)
    
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
            var from: Amount?
            var to: Amount?
            
            var fromFee: Amount?
            var toFee: Amount?
            
            var minMaxToggleValue: FESegmentControl.Values?
            var baseBalance: Amount?
            var minimumAmount: Decimal?
        }
        
        struct ResponseDisplay {
            var continueEnabled = false
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
            var rate: Decimal?
            var from: Currency?
            var to: Currency?
            var expires: Double?
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
            var from: Amount?
            var to: Amount?
            var quote: Quote?
            var fromFee: Amount?
            var toFee: Amount?
        }
        
        struct ResponseDisplay {
            var config: WrapperPopupConfiguration<SwapConfimationConfiguration>
            var viewModel: WrapperPopupViewModel<SwapConfirmationViewModel>
        }
    }
    
    struct Confirm {
        struct ViewAction {
            var pin: String?
        }
        struct ActionResponse {
            var from: String?
            var to: String?
            var exchangeId: String?
        }
        
        struct ResponseDisplay {
            var from: String
            var to: String
            var exchangeId: String
        }
    }
    
    struct InfoPopup {
        struct ViewAction {}
        struct ActionResponse {}
        struct ResponseDisplay {
            var popupViewModel: PopupViewModel
            var popupConfig: PopupConfiguration
        }
    }
}
