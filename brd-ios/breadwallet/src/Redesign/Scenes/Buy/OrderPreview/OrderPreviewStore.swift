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
import WalletKit

class OrderPreviewStore: NSObject, BaseDataStore, OrderPreviewDataStore {
    var itemId: String?
    
    // MARK: - OrderPreviewDataStore
    var to: Amount?
    var from: Decimal?
    var toCurrency: String?
    var card: PaymentCard?
    var quote: Quote?
    var networkFee: Amount?
    var cvv: String?
    var paymentReference: String?
    var paymentstatus: AddCard.Status?
    
    // MARK: - Aditional helpers
    var coreSystem: CoreSystem?
    var keyStore: KeyStore?
}
