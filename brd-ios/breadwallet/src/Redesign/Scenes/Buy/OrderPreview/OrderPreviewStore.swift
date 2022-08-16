//
//  OrderPreviewStore.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class OrderPreviewStore: NSObject, BaseDataStore, OrderPreviewDataStore {
    var itemId: String?
    var to: Amount?
    var from: Decimal?
    var toCurrency: String?
    var card: PaymentCard?
    var cardFee: Decimal?
    var networkFee: Decimal?
    // MARK: - OrderPreviewDataStore

    // MARK: - Aditional helpers
}
