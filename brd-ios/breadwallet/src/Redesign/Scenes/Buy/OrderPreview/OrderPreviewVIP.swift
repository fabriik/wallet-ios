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
    var fromCurrency: String? { get }
}

protocol OrderPreviewDataPassing {
    var dataStore: OrderPreviewDataStore? { get }
}

protocol OrderPreviewRoutes: CoordinatableRoutes {
}
