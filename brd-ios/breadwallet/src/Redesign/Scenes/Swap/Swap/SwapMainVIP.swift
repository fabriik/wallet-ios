//
//  SwapVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let Swap = SwapViewController.self
}

protocol SwapViewActions: BaseViewActions, FetchViewActions {
    func setAmount(viewAction: SwapModels.Amounts.ViewAction)
    func updateRate(viewAction: SwapModels.Rate.ViewAction)
    func switchPlaces(viewAction: SwapModels.SwitchPlaces.ViewAction)
    func selectAsset(viewAction: SwapModels.Assets.ViewAction)
}

protocol SwapActionResponses: BaseActionResponses, FetchActionResponses {
    func presentSetAmount(actionResponse: SwapModels.Amounts.ActionResponse)
    func presentUpdateRate(actionResponse: SwapModels.Rate.ActionResponse)
    func presentSelectAsset(actionResponse: SwapModels.Assets.ActionResponse)
}

protocol SwapResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displaySetAmount(responseDisplay: SwapModels.Amounts.ResponseDisplay)
    func displayUpdateRate(responseDisplay: SwapModels.Rate.ResponseDisplay)
    func displaySelectAsset(responseDisplay: SwapModels.Assets.ResponseDisplay)
}

protocol SwapDataStore: BaseDataStore, FetchDataStore {
    var fromFiatAmount: Decimal? { get set }
    var fromCryptoAmount: Decimal? { get set }
    var toFiatAmount: Decimal? { get set }
    var toCryptoAmount: Decimal? { get set }
    
    var fromBaseFiatFee: Decimal? { get set }
    var fromBaseCryptoFee: Decimal? { get set }
    
    var fromTermFiatFee: Decimal? { get set }
    var fromTermCryptoFee: Decimal? { get set }
    
    var minMaxToggleValue: FESegmentControl.Values? { get set }
    var defaultCurrencyCode: String? { get set }
    
    var baseCurrencies: [String] { get set }
    var termCurrencies: [String] { get set }
    var baseAndTermCurrencies: [[String]] { get set }
    
    var selectedBaseCurrency: String? { get set }
    var selectedTermCurrency: String? { get set }
    
    var currencies: [Currency] { get set }
    var coreSystem: CoreSystem? { get set }
    var keyStore: KeyStore? { get set }
}

protocol SwapDataPassing {
    var dataStore: SwapDataStore? { get }
}

protocol SwapRoutes: CoordinatableRoutes {
    func showAssetSelector(assets: [String]?, selected: ((Any?) -> Void)?)
}
