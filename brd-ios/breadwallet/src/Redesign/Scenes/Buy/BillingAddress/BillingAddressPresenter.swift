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
                DoubleHorizontalTextboxViewModel(first: .init(title: "First Name",
                                                              value: item.firstName,
                                                              validator: { $0?.isEmpty == false }),
                                                 second: .init(title: "Last Name",
                                                               value: item.lastName,
                                                               validator: { $0?.isEmpty == false }))
            ],
            .country: [
                TextFieldModel(title: "Country",
                               value: item.countryFullName,
                               trailing: .imageName("chevrondown"),
                               validator: { $0?.isEmpty == false })
            ],
            .stateProvince: [
                TextFieldModel(title: "State/Province",
                               value: item.stateProvince,
                               validator: { $0?.isEmpty == false })
            ],
            .cityAndZipPostal: [
                DoubleHorizontalTextboxViewModel(first: .init(title: "City",
                                                              value: item.city,
                                                              validator: { $0?.isEmpty == false }),
                                                 second: .init(title: "ZIP/Postal Code",
                                                               value: item.zipPostal,
                                                               validator: { $0?.isEmpty == false }))
            ],
            .address: [
                TextFieldModel(title: "Address",
                               value: item.address,
                               validator: { $0?.isEmpty == false })
            ],
            .confirm: [
                ButtonViewModel(title: "Confirm")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentValidate(actionResponse: BillingAddressModels.Validate.ActionResponse) {
        let isValid = FieldValidator.validate(fields: [actionResponse.item?.firstName,
                                                       actionResponse.item?.lastName,
                                                       actionResponse.item?.country,
                                                       actionResponse.item?.stateProvince,
                                                       actionResponse.item?.city,
                                                       actionResponse.item?.zipPostal,
                                                       actionResponse.item?.address])
        
        viewController?.displayValidate(responseDisplay: .init(isValid: isValid))
    }
    
    func presentSubmit(actionResponse: BillingAddressModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init())
    }
}
