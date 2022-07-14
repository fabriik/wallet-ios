//
//  AssetSelectionModels.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

enum AssetSelectionModels {
    typealias Item = [AssetViewModel]
    
    enum Sections: Sectionable {
        case items
        
        var header: AccessoryType? { nil }
        var footer: AccessoryType? { nil }
    }
    
    enum Search {
        struct ViewAction {
            let text: String?
        }
    }
}
