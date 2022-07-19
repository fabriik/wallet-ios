//
//  AssetSelectionVIP.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

extension Scenes {
    static let AssetSelection = AssetSelectionViewController.self
}

protocol AssetSelectionViewActions: BaseViewActions, FetchViewActions {
}

protocol AssetSelectionActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol AssetSelectionResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol AssetSelectionDataStore: BaseDataStore, FetchDataStore {
    var currencies: [Currency]? { get set }
    var supportedCurrencies: [String]? { get set }
}

protocol AssetSelectionDataPassing {
    var dataStore: AssetSelectionDataStore? { get }
}

protocol AssetSelectionRoutes: CoordinatableRoutes {
}
