//
//  ProfileStore.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//
//

import UIKit

class ProfileStore: NSObject, BaseDataStore, ProfileDataStore {
    // MARK: - ProfileDataStore
    var itemId: String?
    var profile: Profile?
    // MARK: - Aditional helpers
}
