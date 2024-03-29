//
//  AddCardPresenter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class AddCardPresenter: NSObject, Presenter, AddCardActionResponses {
    typealias Models = AddCardModels

    weak var viewController: AddCardViewController?

    // MARK: - AddCardActionResponses
    
    private var bankCardInputDetailsViewModel: BankCardInputDetailsViewModel = .init()
    
    // MARK: - Additional Helpers
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        
        let sections: [Models.Section] = [
            .cardDetails,
            .confirm
        ]
        
        let trailingImage = UIImage(named: "help")?.withRenderingMode(.alwaysOriginal)
        bankCardInputDetailsViewModel = BankCardInputDetailsViewModel(number: .init(leading: .imageName("credit_card_icon"),
                                                                                    title: L10n.Buy.cardNumber,
                                                                                    value: item.cardNumber),
                                                                      expiration: .init(title: L10n.Buy.monthYear,
                                                                                        value: item.cardExpDateString),
                                                                      cvv: .init(title: L10n.Buy.cardCVV,
                                                                                 value: item.cardCVV,
                                                                                 trailing: .image(trailingImage)))
        
        let sectionRows: [Models.Section: [Any]] = [
            .cardDetails: [
                bankCardInputDetailsViewModel
            ],
            .confirm: [
                ButtonViewModel(title: L10n.Button.confirm)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentCardInfo(actionResponse: AddCardModels.CardInfo.ActionResponse) {
        bankCardInputDetailsViewModel.number?.value = actionResponse.dataStore?.cardNumber?.chunkFormatted()
        bankCardInputDetailsViewModel.expiration?.value = actionResponse.dataStore?.cardExpDateString
        bankCardInputDetailsViewModel.cvv?.value = actionResponse.dataStore?.cardCVV
        
        viewController?.displayCardInfo(responseDisplay: .init(model: bankCardInputDetailsViewModel))
    }
    
    func presentValidate(actionResponse: AddCardModels.Validate.ActionResponse) {
        viewController?.displayValidate(responseDisplay: .init(isValid: actionResponse.isValid))
    }
    
    func presentSubmit(actionResponse: AddCardModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init(checkoutToken: actionResponse.checkoutToken))
    }
    
    func presentCvvInfoPopup(actionResponse: AddCardModels.CvvInfoPopup.ActionResponse) {
        let model = PopupViewModel(title: .text(L10n.Buy.securityCode),
                                   imageName: "creditCard",
                                   body: L10n.Buy.securityCodePopup)
        
        viewController?.displayCvvInfoPopup(responseDisplay: .init(model: model))
    }
}
