//
//  OrderPreviewModels.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum OrderPreviewModels {
    
    typealias Item = (to: Amount?, from: Decimal?, quote: Quote?, card: PaymentCard?)
    
    enum Sections: Sectionable {
        case orderInfoCard
        case payment
        case termsAndConditions
        case submit
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct InfoPopup {
        struct ViewAction {
            var isCardFee: Bool
        }
        struct ActionResponse {
            var isCardFee: Bool
        }
        struct ResponseDisplay {
            var model: PopupViewModel
        }
    }
    
    struct ThreeDSecure {
        struct ActionResponse {
            var url: URL
        }
        
        struct ResponseDisplay {
            var url: URL
        }
    }
    
    struct ThreeDSecureStatus {
        struct ViewAction {}
    }
    
    struct CVVValidation {
        struct ViewAction {
            var cvv: String?
        }
        
        struct ActionResponse {
            var cvv: String?
        }
        
        struct ResponseDisplay {
            var continueEnabled: Bool
        }
    }
    
    struct Submit {
        struct ViewAction {}
        
        struct ActionResponse {
            var paymentReference: String
        }
        
        struct ResponseDisplay {
            var paymentReference: String
        }
    }
}
