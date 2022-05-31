//
//  PersonalInfoStore.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

class PersonalInfoStore: NSObject, BaseDataStore, PersonalInfoDataStore {
    // MARK: - PersonalInfoDataStore
    // user id or smth?
    var itemId: String?
    var firstName: String?
    var lastName: String?
    var country: String?
    var birthdate: Date?

    // MARK: - Aditional helpers
}