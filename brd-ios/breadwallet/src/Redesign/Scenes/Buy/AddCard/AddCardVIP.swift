//
//  AddCardVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let AddCard = AddCardViewController.self
}

protocol AddCardViewActions: BaseViewActions, FetchViewActions {
    func cardNumberAndCVVSet(viewAction: AddCardModels.CardNumberAndCVV.ViewAction)
    func cardExpDateSet(viewAction: AddCardModels.CardExpDate.ViewAction)
}

protocol AddCardActionResponses: BaseActionResponses, FetchActionResponses {
    func presentValidate(actionResponse: AddCardModels.Validate.ActionResponse)
    func presentSubmit(actionResponse: AddCardModels.Submit.ActionResponse)
}

protocol AddCardResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayValidate(responseDisplay: AddCardModels.Validate.ResponseDisplay)
    func displaySubmit(responseDisplay: AddCardModels.Submit.ResponseDisplay)
}

protocol AddCardDataStore: BaseDataStore, FetchDataStore {
    var cardNumber: String? { get set }
    var cardExpDateString: String? { get set }
    var cardCVV: String? { get set }
    var monthsYears: AddCardModels.MonthsYears? { get set }
}

protocol AddCardDataPassing {
    var dataStore: AddCardDataStore? { get }
}

protocol AddCardRoutes: CoordinatableRoutes {
}
