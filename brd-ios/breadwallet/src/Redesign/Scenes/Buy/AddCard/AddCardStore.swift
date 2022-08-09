//
//  AddCardStore.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class AddCardStore: NSObject, BaseDataStore, AddCardDataStore {
    // MARK: - AddCardDataStore
    
    var itemId: String?
    var cardNumber: String?
    var cardExpDateString: String?
    var cardCVV: String?
    var months: [String] = []
    var years: [String] = []
    var paymentReference: String?
    var paymentstatus: AddCard.Status = .CANCELED
    
    // MARK: - Aditional helpers
}
