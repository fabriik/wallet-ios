//
//  DeleteKYCProfileInfoModels.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum DeleteKYCProfileInfoModels {
    typealias Item = Any?
    
    enum Section: Sectionable {
        case title
        case checkmarks
        case tickbox
        case confirm
        
        var header: AccessoryType? { return nil }
        var footer: AccessoryType? { return nil }
    }
    
    struct Tickbox {
        struct ViewAction {
            var value: Bool
        }
        
        struct ActionResponse {
            var value: Bool
        }
        
        struct ResponseDisplay {
            var model: ButtonViewModel
        }
    }
}
