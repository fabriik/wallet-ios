//
//  OrderPreviewPresenter.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class OrderPreviewPresenter: NSObject, Presenter, OrderPreviewActionResponses {
    
    typealias Models = OrderPreviewModels

    weak var viewController: OrderPreviewViewController?

    // MARK: - OrderPreviewActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        
        let sections: [Models.Sections] = [
            .orderInfoCard,
            .payment,
            .termsAndConditions,
            .confirm
        ]
        
        // TODO: localize and change values when BE is ready
        guard let infoImage = UIImage(named: "help")?.withRenderingMode(.alwaysOriginal) else { return }
        
        let wrappedViewModel: BuyOrderViewModel = .init(price: .init(title: .text("Price"), value: .text("$64.22 USD")),
                                                        amount: .init(title: .text("Amount"), value: .text("$100 USD")),
                                                        cardFee: .init(title: .text("Card fee (4%)"), value: .text("$4.00 USD"), infoImage: .image(infoImage)),
                                                        networkFee: .init(title: .text("Mining network fee"), value: .text("$1.00 USD"), infoImage: .image(infoImage)),
                                                        totalCost: .init(title: .text("Total:"), value: .text("$105.00 USD")))
        
        let sectionRows: [Models.Sections: [Any]] = [
            .orderInfoCard: [
                wrappedViewModel
            ],
            .termsAndConditions: [
                LabelViewModel.text("By placing this order you agree to our Terms and Conditions")
            ],
            .confirm: [
                ButtonViewModel(title: "Confirm")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentInfoPopup(actionResponse: OrderPreviewModels.InfoPopup.ActionResponse) {
        let model = actionResponse.isCardFee ? Presets.BuyPopupView.cardFee : Presets.BuyPopupView.networkFee
        
        viewController?.displayInfoPopup(responseDisplay: .init(model: model))
    }

    // MARK: - Additional Helpers

}
