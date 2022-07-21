//
//  SwapInfoVIP.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

extension Scenes {
    static let SwapInfo = SwapInfoViewController.self
}

protocol SwapInfoViewActions: BaseViewActions, FetchViewActions {
}

protocol SwapInfoActionResponses: BaseActionResponses, FetchActionResponses {
}

protocol SwapInfoResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
}

protocol SwapInfoDataStore: BaseDataStore, FetchDataStore {
    var from: String { get set }
    var to: String { get set }
}

protocol SwapInfoDataPassing {
    var dataStore: SwapInfoDataStore? { get }
}

protocol SwapInfoRoutes: CoordinatableRoutes {
    func showSwapDetails()
}
