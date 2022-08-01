//
//  BillingAddressModels.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum BillingAddressModels {
    typealias Item = BillingAddressStore
 
    enum Section: Sectionable {
        case name
        case country
        case stateProvince
        case cityAndZipPostal
        case address
        case confirm
        
        var header: AccessoryType? { nil }
        var footer: AccessoryType? { nil }
    }
    
    struct Name {
        struct ViewAction {
            var first: String?
            var last: String?
        }
    }
    
    struct StateProvince {
        struct ViewAction {
            var stateProvince: String?
        }
    }
    
    struct Address {
        struct ViewAction {
            var address: String?
        }
    }
    
    struct CityAndZipPostal {
        struct ViewAction {
            var city: String?
            var zipPostal: String?
        }
    }
    
    struct Country {
        struct ViewAction {
            var code: String?
            var countryFullName: String?
        }
    }
    
    struct Validate {
        struct ViewAction {}
        
        struct ActionResponse {
            var item: Item?
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
