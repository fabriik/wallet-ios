//
//  SwapInfoStore.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

class SwapInfoStore: NSObject, BaseDataStore, SwapInfoDataStore {
    
    var itemId: String?
    
    // MARK: - SwapInfoDataStore
    var from: String = "BSV"
    var to: String = "BTC"

    // MARK: - Aditional helpers
}
