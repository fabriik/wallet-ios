//
//  OrderPreviewVIP.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let OrderPreview = OrderPreviewViewController.self
}

protocol OrderPreviewViewActions: BaseViewActions, FetchViewActions {
    func showInfoPopup(viewAction: OrderPreviewModels.InfoPopup.ViewAction)
    func updateCvv(viewAction: OrderPreviewModels.CvvValidation.ViewAction)
    func submit(viewAction: OrderPreviewModels.Submit.ViewAction)
}

protocol OrderPreviewActionResponses: BaseActionResponses, FetchActionResponses {
    func presentInfoPopup(actionResponse: OrderPreviewModels.InfoPopup.ActionResponse)
    func presentCvv(actionResponse: OrderPreviewModels.CvvValidation.ActionResponse)
    func presentSubmit(actionResponse: OrderPreviewModels.Submit.ActionResponse)
}

protocol OrderPreviewResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayInfoPopup(responseDisplay: OrderPreviewModels.InfoPopup.ResponseDisplay)
    func displayCvv(responseDisplay: OrderPreviewModels.CvvValidation.ResponseDisplay)
    func displaySubmit(responseDisplay: OrderPreviewModels.Submit.ResponseDisplay)
}

protocol OrderPreviewDataStore: BaseDataStore, FetchDataStore {
    var to: Amount? { get set }
    var from: Decimal? { get set }
    var toCurrency: String? { get set }
    var card: PaymentCard? { get set }
    var quote: Quote? { get set }
    var cvv: String? { get set }
    var paymentReference: String? { get set }
    var paymentstatus: AddCard.Status? { get set }
}

protocol OrderPreviewDataPassing {
    var dataStore: OrderPreviewDataStore? { get }
}

protocol OrderPreviewRoutes: CoordinatableRoutes {
    func showOrderPreview(coreSystem: CoreSystem?, keyStore: KeyStore?, to: Amount?, from: Decimal?, card: PaymentCard?, quote: Quote?)
}
