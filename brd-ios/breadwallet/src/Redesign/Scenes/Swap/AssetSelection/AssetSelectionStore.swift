//
//  AssetSelectionStore.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

class AssetSelectionStore: NSObject, BaseDataStore, AssetSelectionDataStore {
    
    // MARK: - AssetSelectionDataStore
    var itemId: String?
    var assets: [Any] = []

    // MARK: - Aditional helpers
}
