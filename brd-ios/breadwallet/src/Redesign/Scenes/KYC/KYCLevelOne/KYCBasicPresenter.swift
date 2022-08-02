//
//  KYCBasicPresenter.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

final class KYCBasicPresenter: NSObject, Presenter, KYCBasicActionResponses {
    typealias Models = KYCBasicModels

    weak var viewController: KYCBasicViewController?

    // MARK: - KYCBasicActionResponses

    // MARK: - Additional Helpers
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        let sections: [Models.Section] = [
            .name,
            .country,
            .birthdate,
            .confirm
        ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .name: [
                DoubleHorizontalTextboxViewModel(title: .text("Write your name as it appears on your ID"),
                                                 first: .init(title: "First Name", value: item.firstName),
                                                 second: .init(title: "Last Name", value: item.lastName))
            ],
            .country: [
                TextFieldModel(title: "Country",
                               value: item.countryFullName,
                               trailing: .imageName("chevrondown"))
            ],
            .birthdate: [
                DateViewModel(date: item.birthdate)
            ],
            .confirm: [
                ButtonViewModel(title: "Confirm")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentValidate(actionResponse: KYCBasicModels.Validate.ActionResponse) {
        viewController?.displayValidate(responseDisplay: .init(isValid: actionResponse.isValid))
    }
    
    func presentSubmit(actionResponse: KYCBasicModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init())
    }
}
