//
//  PaymentsModels.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.10.22.
//
//

import UIKit

enum PaymentsModels {
    
    struct Item {
        var items: [ItemSelectable]?
        var isAddingEnabled: Bool?
    }
    
    enum Sections: Sectionable {
        case addItem
        case items
        
        var header: AccessoryType? { nil }
        var footer: AccessoryType? { nil }
    }
    
    enum Search {
        struct ViewAction {
            let text: String?
        }
    }
    
    struct ActionSheet {
        struct ViewAction {
            var instrumentId: String
        }
        
        struct ActionResponse {
            var instrumentId: String
        }
        
        struct ResponseDisplay {
            var instrumentId: String
            var actionSheetOkButton: String
            var actionSheetCancelButton: String

        }
    }
    
    struct RemovePayment {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {}
    }
    
    struct RemovePaymenetPopup {
        struct ViewAction {
            var instrumentID: String
        }
        
        struct ActionResponse {}
        
        struct ResponseDisplay {
            var popupViewModel: PopupViewModel
            var popupConfig: PopupConfiguration
        }
    }
}
