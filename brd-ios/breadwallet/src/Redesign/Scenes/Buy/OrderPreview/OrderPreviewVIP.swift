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
}

protocol OrderPreviewActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol OrderPreviewResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol OrderPreviewDataStore: BaseDataStore, FetchDataStore {
}

protocol OrderPreviewDataPassing {
    var dataStore: OrderPreviewDataStore? { get }
}

protocol OrderPreviewRoutes: CoordinatableRoutes {
}
