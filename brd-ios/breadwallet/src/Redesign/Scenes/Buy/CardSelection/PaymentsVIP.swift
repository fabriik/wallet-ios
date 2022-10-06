//
//  PaymentsVIP.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.10.22.
//
//

import UIKit

extension Scenes {
    static let Payments = PaymentsViewController.self
}

protocol PaymentsViewActions: BaseViewActions, FetchViewActions {
    func removePaymenetPopup(viewAction: PaymentsModels.RemovePaymenetPopup.ViewAction)
    func removePayment(viewAction: PaymentsModels.RemovePayment.ViewAction)
}

protocol PaymentsActionResponses: BaseActionResponses, FetchActionResponses {
    func presentRemovePaymentPopup(actionResponse: PaymentsModels.RemovePaymenetPopup.ActionResponse)
    func presentRemovePaymentMessage(actionResponse: PaymentsModels.RemovePayment.ActionResponse)
}

protocol PaymentsResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayRemovePaymentPopup(responseDisplay: PaymentsModels.RemovePaymenetPopup.ResponseDisplay)
    func displayRemovePaymentSuccess(responseDisplay: PaymentsModels.RemovePayment.ResponseDisplay)
}

protocol PaymentsDataStore: BaseDataStore, FetchDataStore {
    var items: [ItemSelectable]? { get set }
    var isAddingEnabled: Bool? { get set }
    var instrumentID: String? { get set }
}

protocol PaymentsDataPassing {
    var dataStore: PaymentsDataStore? { get }
}

protocol PaymentsRoutes: CoordinatableRoutes {
}
