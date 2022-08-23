//
//  BillingAddressPresenter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class BillingAddressPresenter: NSObject, Presenter, BillingAddressActionResponses {
    typealias Models = BillingAddressModels

    weak var viewController: BillingAddressViewController?

    // MARK: - BillingAddressActionResponses

    // MARK: - Additional Helpers
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        let sections: [Models.Section] = [
            .name,
            .country,
            .stateProvince,
            .cityAndZipPostal,
            .address,
            .confirm
        ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .name: [
                DoubleHorizontalTextboxViewModel(primary: .init(title: "First Name",
                                                                value: item.firstName),
                                                 secondary: .init(title: "Last Name",
                                                                  value: item.lastName))
            ],
            .country: [
                TextFieldModel(title: "Country",
                               value: item.countryFullName,
                               trailing: .imageName("chevrondown"))
            ],
            .stateProvince: [
                TextFieldModel(title: "State/Province",
                               value: item.stateProvince)
            ],
            .cityAndZipPostal: [
                DoubleHorizontalTextboxViewModel(primary: .init(title: "City",
                                                                value: item.city),
                                                 secondary: .init(title: "ZIP/Postal Code",
                                                                  value: item.zipPostal))
            ],
            .address: [
                TextFieldModel(title: "Address",
                               value: item.address)
            ],
            .confirm: [
                ButtonViewModel(title: "Confirm")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentCountry(actionResponse: BillingAddressModels.SelectCountry.ActionResponse) {
        guard let countries = actionResponse.countries else { return }
        viewController?.displayCountry(responseDisplay: .init(countries: countries))
    }
    
    func presentPaymentCards(actionResponse: BillingAddressModels.PaymentCards.ActionResponse) {
        viewController?.displayPaymentCards(responseDisplay: .init(allPaymentCards: actionResponse.allPaymentCards ?? []))
    }
    
    func presentThreeDSecure(actionResponse: BillingAddressModels.ThreeDSecure.ActionResponse) {
        viewController?.displayThreeDSecure(responseDisplay: .init(url: actionResponse.url))
    }
    
    func presentValidate(actionResponse: BillingAddressModels.Validate.ActionResponse) {
        viewController?.displayValidate(responseDisplay: .init(isValid: actionResponse.isValid))
    }
    
    func presentSubmit(actionResponse: BillingAddressModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init())
    }
}
