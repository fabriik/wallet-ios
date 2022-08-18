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
import WalletKit

final class OrderPreviewPresenter: NSObject, Presenter, OrderPreviewActionResponses {
    
    typealias Models = OrderPreviewModels

    weak var viewController: OrderPreviewViewController?

    // MARK: - OrderPreviewActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let toAmount = item.to,
              let quote = item.quote,
              let infoImage = UIImage(named: "help")?.withRenderingMode(.alwaysOriginal),
              let card = item.card else { return }
        
        let currencyFormatter = "%.2f %@"
        
        let to = toAmount.fiatValue
        let from = item.from ?? 0
        let cardFee = from * (quote.buyFee ?? 0) / 100
        let networkFee = item.networkFee?.fiatValue ?? 0
        let fiatCurrency = (quote.fromFeeCurrency?.feeCurrency ?? "USD").uppercased()
        
        let fromText = String(format: currencyFormatter, from.doubleValue, fiatCurrency)
        let amountText = String(format: currencyFormatter, to.doubleValue, fiatCurrency)
        let cardFeeText = String(format: currencyFormatter, cardFee.doubleValue, fiatCurrency)
        let networkFeeText = String(format: currencyFormatter, networkFee.doubleValue, fiatCurrency)
        
        let rate = String(format: "1 %@ = %@", toAmount.currency.code, String(format: currencyFormatter, 1 / quote.exchangeRate.doubleValue, fiatCurrency))
        let totalText = String(format: currencyFormatter, (to + networkFee + cardFee).doubleValue, fiatCurrency)
        let wrappedViewModel: BuyOrderViewModel = .init(rate: .init(exchangeRate: rate, timer: nil),
                                                        price: .init(title: .text("Price"), value: .text(fromText)),
                                                        amount: .init(title: .text("Amount"), value: .text(amountText)),
                                                        cardFee: .init(title: .text("Card fee (\(quote.buyFee ?? 0)%)"), value: .text(cardFeeText), infoImage: .image(infoImage)),
                                                        networkFee: .init(title: .text("Mining network fee"), value: .text(networkFeeText), infoImage: .image(infoImage)),
                                                        totalCost: .init(title: .text("Total:"), value: .text(totalText)))
        
        let sections: [Models.Sections] = [
            .orderInfoCard,
            .payment,
            .termsAndConditions,
            .submit
        ]
        
        let imageVM: ImageViewModel
        if let image = card.image {
            imageVM = .image(image)
        } else {
            imageVM = .imageName("credit_card_icon")
        }
        let sectionRows: [Models.Sections: [Any]] = [
            .orderInfoCard: [
                wrappedViewModel
            ],
            .payment: [
                PaymentMethodViewModel(logo: imageVM,
                                       cardNumber: .text(CardDetailsFormatter.formatNumber(last4: card.last4)),
                                       expiration: .text(CardDetailsFormatter.formatExpirationDate(month: card.expiryMonth, year: card.expiryYear)))
            ],
            .termsAndConditions: [
                LabelViewModel.text("By placing this order you agree to our Terms and Conditions")
            ],
            .submit: [
                ButtonViewModel(title: "Confirm", enabled: false)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentInfoPopup(actionResponse: OrderPreviewModels.InfoPopup.ActionResponse) {
        let model = actionResponse.isCardFee ? Presets.BuyPopupView.cardFee : Presets.BuyPopupView.networkFee
        
        viewController?.displayInfoPopup(responseDisplay: .init(model: model))
    }
    
    func presentThreeDSecure(actionResponse: OrderPreviewModels.ThreeDSecure.ActionResponse) {
        viewController?.displayThreeDSecure(responseDisplay: .init(url: actionResponse.url))
    }
    
    func presentCvv(actionResponse: OrderPreviewModels.CvvValidation.ActionResponse) {
        let enabled = actionResponse.cvv?.count == 3
        viewController?.displayCvv(responseDisplay: .init(continueEnabled: enabled))
    }
    
    func presentSubmit(actionResponse: OrderPreviewModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init(paymentReference: actionResponse.paymentReference))
    }
    
    // MARK: - Additional Helpers

}
