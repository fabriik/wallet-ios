//
//  BillingAddressVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let BillingAddress = BillingAddressViewController.self
}

protocol BillingAddressViewActions: BaseViewActions, FetchViewActions {
    func countrySelected(viewAction: BillingAddressModels.Country.ViewAction)
    func nameSet(viewAction: BillingAddressModels.Name.ViewAction)
    func cityAndZipPostalSet(viewAction: BillingAddressModels.CityAndZipPostal.ViewAction)
    func stateProvinceSet(viewAction: BillingAddressModels.StateProvince.ViewAction)
    func addressSet(viewAction: BillingAddressModels.Address.ViewAction)
    func validate(viewAction: BillingAddressModels.Validate.ViewAction)
    func submit(vieAction: BillingAddressModels.Submit.ViewAction)
}

protocol BillingAddressActionResponses: BaseActionResponses, FetchActionResponses {
    func presentValidate(actionResponse: BillingAddressModels.Validate.ActionResponse)
    func presentSubmit(actionResponse: BillingAddressModels.Submit.ActionResponse)
}

protocol BillingAddressResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayValidate(responseDisplay: BillingAddressModels.Validate.ResponseDisplay)
    func displaySubmit(responseDisplay: BillingAddressModels.Submit.ResponseDisplay)
}

protocol BillingAddressDataStore: BaseDataStore, FetchDataStore {
    var firstName: String? { get set }
    var lastName: String? { get set }
    var country: String? { get set }
    var countryFullName: String? { get set }
    var stateProvince: String? { get set }
    var city: String? { get set }
    var zipPostal: String? { get set }
    var address: String? { get set }
}

protocol BillingAddressDataPassing {
    var dataStore: BillingAddressDataStore? { get }
}

protocol BillingAddressRoutes: CoordinatableRoutes {
    func showCountrySelector(selected: ((CountryResponseData?) -> Void)?)
}
