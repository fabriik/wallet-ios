//
//  ItemSelectionVIP.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

extension Scenes {
    static let ItemSelection = ItemSelectionViewController.self
}

protocol ItemSelectionViewActions: BaseViewActions, FetchViewActions {
    func removePaymenetPopup(viewAction: ItemSelectionModels.RemovePaymenetPopup.ViewAction)
}

protocol ItemSelectionActionResponses: BaseActionResponses, FetchActionResponses {
    func presentRemovePaymentPopup(actionResponse: ItemSelectionModels.RemovePaymenetPopup.ActionResponse)
}

protocol ItemSelectionResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayRemovePaymentPopup(responseDisplay: ItemSelectionModels.RemovePaymenetPopup.ResponseDisplay)
}

protocol ItemSelectionDataStore: BaseDataStore, FetchDataStore {
    var items: [ItemSelectable]? { get set }
    var isAddingEnabled: Bool? { get set }
}

protocol ItemSelectionDataPassing {
    var dataStore: ItemSelectionDataStore? { get }
}

protocol ItemSelectionRoutes: CoordinatableRoutes {
}
