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
        guard let item = actionResponse.item as? Models.Item,
              let toAmount = item.to,
              let quote = item.quote,
              let infoImage = UIImage(named: "help")?.withRenderingMode(.alwaysOriginal) else { return }
        
        let to = toAmount.fiatValue
        let from = item.from ?? 0
        let cardFee = quote.fromFeeCurrency?.rate ?? 0
        let networkFee = quote.toFeeCurrency?.rate ?? 0
        let fiatCurrency = quote.fromFeeCurrency?.feeCurrency ?? "/"
        let feeCurrency = quote.toFeeCurrency?.feeCurrency ?? "/"
        
        // TODO: pass exchange rate / expiration as well
        // TODO: format currency
        let rate = String(format: "1 %@ = %.5f %@", toAmount.currency.code, quote.exchangeRate.doubleValue, fiatCurrency)
        let wrappedViewModel: BuyOrderViewModel = .init(rate: .init(exchangeRate: rate, timer: nil),
                                                        price: .init(title: .text("Price"), value: .text("\(from) \(fiatCurrency)")),
                                                        amount: .init(title: .text("Amount"), value: .text("\(to) \(fiatCurrency)")),
                                                        cardFee: .init(title: .text("Card fee (4%)"), value: .text("\(cardFee.description) \(fiatCurrency)"), infoImage: .image(infoImage)),
                                                        networkFee: .init(title: .text("Mining network fee"), value: .text("\(networkFee.description) \(feeCurrency)"), infoImage: .image(infoImage)),
                                                        totalCost: .init(title: .text("Total:"), value: .text("\(to + networkFee + cardFee) \(fiatCurrency)")))
        
        let sections: [Models.Sections] = [
            .orderInfoCard,
            .payment,
            .termsAndConditions,
            .confirm
        ]
        
        let sectionRows: [Models.Sections: [Any]] = [
            .orderInfoCard: [
                wrappedViewModel
            ],
            .payment: [
                PaymentMethodViewModel()
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
    
    func presentConfirm(actionResponse: OrderPreviewModels.Confirm.ActionResponse) {
        viewController?.displayConfirm(responseDisplay: .init())
    }
    
    func presentCvv(actionResponse: OrderPreviewModels.CvvValidation.ActionResponse) {
        let enabled = actionResponse.cvv?.count == 3
        viewController?.displayCvv(responseDisplay: .init(continueEnabled: enabled))
    }

    // MARK: - Additional Helpers

}
