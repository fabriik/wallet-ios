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
    var cvv: String?
    
    // MARK: - Aditional helpers
    var coreSystem: CoreSystem?
    
    func address(for currency: Currency?) -> String? {
        guard let currency = currency else {
            return nil
        }

        let addressScheme: AddressScheme
        if currency.isBitcoin {
            addressScheme = UserDefaults.hasOptedInSegwit ? .btcSegwit : .btcLegacy
        } else {
            addressScheme = currency.network.defaultAddressScheme
        }
        return currency.wallet?.receiveAddress(for: addressScheme)
    }
}
