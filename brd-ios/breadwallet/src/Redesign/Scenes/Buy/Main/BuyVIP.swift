//
//  BuyVIP.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

extension Scenes {
    static let Buy = BuyViewController.self
}

protocol BuyViewActions: BaseViewActions, FetchViewActions {
    func setAmount(viewAction: BuyModels.Amounts.ViewAction)
    func getExchangeRate(viewAction: BuyModels.Rate.ViewAction)
    func setAssets(viewAction: BuyModels.Assets.ViewAction)
}

protocol BuyActionResponses: BaseActionResponses, FetchActionResponses {
    func presentAmount(actionResponse: BuyModels.Amounts.ActionResponse)
    func presentExchangeRate(actionResponse: BuyModels.Rate.ActionResponse)
}

protocol BuyResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayAmount(actionResponse: BuyModels.Amounts.ResponseDisplay)
    func displayExchangeRate(responseDisplay: BuyModels.Rate.ResponseDisplay)
}

protocol BuyDataStore: BaseDataStore, FetchDataStore {
    var from: Amount? { get set }
    var fromCurrency: Currency? { get set }
    var toCurrency: String? { get set }
    var rate: Decimal? { get set }
}

protocol BuyDataPassing {
    var dataStore: BuyDataStore? { get }
}

protocol BuyRoutes: CoordinatableRoutes {
    // TODO: refactor :S
    func showAssetSelector(currencies: [Currency]?, selected: ((Any?) -> Void)?)
    func showPinInput(callback: ((_ pin: String?) -> Void)?)
    func showInfo(from: String, to: String, exchangeId: String)
}
