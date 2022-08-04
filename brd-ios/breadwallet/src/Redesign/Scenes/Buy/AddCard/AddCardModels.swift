//
//  AddCardModels.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum AddCardModels {
    typealias Item = AddCardStore
    
    enum Section: Sectionable {
        case cardDetails
        case confirm
        
        var header: AccessoryType? { nil }
        var footer: AccessoryType? { nil }
    }
    
    struct CardNumberAndCVV {
        struct ViewAction {
            var number: String?
            var cvv: String?
        }
    }
    
    struct CardExpDate {
        struct ViewAction {
            var index: PickerViewViewController.Index?
        }
    }
    
    struct Validate {
        struct ViewAction {}
        
        struct ActionResponse {
            var isValid: Bool
        }
        
        struct ResponseDisplay {
            var isValid: Bool
        }
    }
    
    struct Submit {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {}
    }
}
