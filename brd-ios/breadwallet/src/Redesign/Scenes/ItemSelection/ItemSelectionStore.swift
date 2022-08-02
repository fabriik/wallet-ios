//
//  ItemSelectionStore.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

class ItemSelectionStore: NSObject, BaseDataStore, ItemSelectionDataStore {
    // MARK: - ItemSelectionDataStore
    var itemId: String?
    var items: [ItemSelectable] = []
    
    // MARK: - Aditional helpers
}
