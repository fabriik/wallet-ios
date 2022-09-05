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
import WalletKit

extension Scenes {
    static let Swap = SwapViewController.self
}

protocol SwapViewActions: BaseViewActions, FetchViewActions, FeeFetchable {
    func setAmount(viewAction: SwapModels.Amounts.ViewAction)
    func getRate(viewAction: SwapModels.Rate.ViewAction)
    func switchPlaces(viewAction: SwapModels.SwitchPlaces.ViewAction)
    func selectAsset(viewAction: SwapModels.Assets.ViewAction)
    func showConfirmation(viewAction: SwapModels.ShowConfirmDialog.ViewAction)
    func confirm(viewAction: SwapModels.Confirm.ViewAction)
    func showInfoPopup(viewAction: SwapModels.InfoPopup.ViewAction)
}

protocol SwapActionResponses: BaseActionResponses, FetchActionResponses {
    func presentAmount(actionResponse: SwapModels.Amounts.ActionResponse)
    func presentRate(actionResponse: SwapModels.Rate.ActionResponse)
    func presentSelectAsset(actionResponse: SwapModels.Assets.ActionResponse)
    func presentConfirmation(actionResponse: SwapModels.ShowConfirmDialog.ActionResponse)
    func presentConfirm(actionResponse: SwapModels.Confirm.ActionResponse)
    func presentInfoPopup(actionResponse: SwapModels.InfoPopup.ActionResponse)
}

protocol SwapResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayAmount(responseDisplay: SwapModels.Amounts.ResponseDisplay)
    func displayRate(responseDisplay: SwapModels.Rate.ResponseDisplay)
    func displaySelectAsset(responseDisplay: SwapModels.Assets.ResponseDisplay)
    func displayConfirmation(responseDisplay: SwapModels.ShowConfirmDialog.ResponseDisplay)
    func displayConfirm(responseDisplay: SwapModels.Confirm.ResponseDisplay)
    func displayInfoPopup(responseDisplay: SwapModels.InfoPopup.ResponseDisplay)
    func displayError(responseDisplay: SwapModels.ErrorPopup.ResponseDisplay)
}

protocol SwapDataStore: BaseDataStore, FetchDataStore {
    var from: Amount? { get set }
    var to: Amount? { get set }
    
    var fromFee: TransferFeeBasis? { get set }
    var toFee: EstimateFee? { get set }
    
    var defaultCurrencyCode: String? { get set }
    
    var quote: Quote? { get set }
    
    var fromRate: Decimal? { get set }
    var toRate: Decimal? { get set }
    
    var baseCurrencies: [String] { get set }
    var termCurrencies: [String] { get set }
    var baseAndTermCurrencies: [[String]] { get set }
    
    var fromCurrency: Currency? { get set }
    var toCurrency: Currency? { get set }
    
    var currencies: [Currency] { get set }
    var coreSystem: CoreSystem? { get set }
    var keyStore: KeyStore? { get set }
    var isKYCLevelTwo: Bool? { get set }
}

protocol SwapDataPassing {
    var dataStore: SwapDataStore? { get }
}

protocol SwapRoutes: CoordinatableRoutes {
    func showAssetSelector(currencies: [Currency]?, supportedCurrencies: [SupportedCurrency]?, selected: ((Any?) -> Void)?)
    func showPinInput(keyStore: KeyStore?, callback: ((_ pin: String?) -> Void)?)
    func showSwapInfo(from: String, to: String, exchangeId: String)
}
