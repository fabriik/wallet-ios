//
//  SwapDetailsStore.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

class SwapDetailsStore: NSObject, BaseDataStore, SwapDetailsDataStore {
    var itemId: String?
    
    // MARK: - SwapDetailsDataStore
    
    var transactionType: Transaction.TransactionType = .defaultTransaction
    
    // MARK: - Aditional helpers
}
