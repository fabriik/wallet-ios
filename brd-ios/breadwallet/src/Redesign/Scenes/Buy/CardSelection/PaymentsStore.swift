//
//  PaymentsStore.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.10.22.
//
//

import UIKit

class PaymentsStore: NSObject, BaseDataStore, PaymentsDataStore {
    // MARK: - PaymentsDataStore
    var itemId: String?
    var items: [ItemSelectable]?
    var instrumentID: String?
    
    /// Enable adding entries
    var isAddingEnabled: Bool? = false
    var isSelectingEnabled: Bool? = true
}
