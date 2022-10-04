//
//  ItemSelectionModels.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

enum ItemSelectionModels {

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
    
    struct RemovePaymenetPopup {
        struct ViewAction {}
        
        struct ActionResponse {}
        
        struct ResponseDisplay {
            var popupViewModel: PopupViewModel
            var popupConfig: PopupConfiguration
        }
    }
}
