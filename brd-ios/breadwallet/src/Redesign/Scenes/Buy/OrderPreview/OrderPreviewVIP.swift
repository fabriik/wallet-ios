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
}

protocol OrderPreviewActionResponses: BaseActionResponses, FetchActionResponses {
    func presentInfoPopup(actionResponse: OrderPreviewModels.InfoPopup.ActionResponse)
}

protocol OrderPreviewResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayInfoPopup(responseDisplay: OrderPreviewModels.InfoPopup.ResponseDisplay)
}

protocol OrderPreviewDataStore: BaseDataStore, FetchDataStore {
    var to: Amount? { get set }
    var from: Decimal? { get set }
    var toCurrency: String? { get set }
    var cardFee: Decimal? { get set}
    var networkFee: Decimal? { get set }
}

protocol OrderPreviewDataPassing {
    var dataStore: OrderPreviewDataStore? { get }
}

protocol OrderPreviewRoutes: CoordinatableRoutes {
    func showOrderPreview(to: Amount?, from: Decimal?, networkFee: Decimal?, cardFee: Decimal?)
}
