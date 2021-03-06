//
//  SwapDetailsVIP.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

extension Scenes {
    static let SwapDetails = SwapDetailsViewController.self
}

protocol SwapDetailsViewActions: BaseViewActions, FetchViewActions {
}

protocol SwapDetailsActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol SwapDetailsResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol SwapDetailsDataStore: BaseDataStore, FetchDataStore {
}

protocol SwapDetailsDataPassing {
    var dataStore: SwapDetailsDataStore? { get }
}

protocol SwapDetailsRoutes: CoordinatableRoutes {
}
