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
        
        let to = toAmount.fiatValue
        let from = item.from ?? 0
        let cardFee = from * (quote.buyFee ?? 0) / 100
        let networkFee = item.networkFee?.fiatValue ?? 0
        let fiatCurrency = (quote.fromFeeCurrency?.feeCurrency ?? C.usdCurrencyCode).uppercased()
        
        let currencyFormatter = "%@ %@"
        let fromText = String(format: currencyFormatter, ExchangeFormatter.fiat.string(for: from) ?? "", fiatCurrency)
        let amountText = String(format: currencyFormatter, ExchangeFormatter.fiat.string(for: to) ?? "", fiatCurrency)
        let cardFeeText = String(format: currencyFormatter, ExchangeFormatter.fiat.string(for: cardFee) ?? "", fiatCurrency)
        let networkFeeText = String(format: currencyFormatter, ExchangeFormatter.fiat.string(for: networkFee) ?? "", fiatCurrency)
        
        let rate = String(format: "1 %@ = %@ %@", toAmount.currency.code, ExchangeFormatter.fiat.string(for: 1 / quote.exchangeRate) ?? "", fiatCurrency)
        let totalText = String(format: currencyFormatter, ExchangeFormatter.fiat.string(for: to + networkFee + cardFee) ?? "", fiatCurrency)
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
        
        let sectionRows: [Models.Sections: [Any]] = [
            .orderInfoCard: [
                wrappedViewModel
            ],
            .payment: [
                PaymentMethodViewModel(logo: card.displayImage,
                                       cardNumber: .text(card.displayName),
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
        let model: PopupViewModel
        
        if  actionResponse.isCardFee,
            let fee = actionResponse.fee {
            let feeText = String(format: "An extra fee of %.0f%% is required to cover processing of credit card purchases.", fee.doubleValue)
            model = .init(title: .text("Card fee"), body: feeText)
        } else {
            
            model = .init(title: .text("Network fees"),
                          body: """
    Network fee prices vary depending on the blockchain in which you are receiving your assets. This is an external fee to cover mining and transaction costs.
    """)
        }
        
        viewController?.displayInfoPopup(responseDisplay: .init(model: model))
    }
    
    func presentThreeDSecure(actionResponse: OrderPreviewModels.ThreeDSecure.ActionResponse) {
        viewController?.displayThreeDSecure(responseDisplay: .init(url: actionResponse.url))
    }
    
    func presentCvv(actionResponse: OrderPreviewModels.CvvValidation.ActionResponse) {
        viewController?.displayCvv(responseDisplay: .init(continueEnabled: actionResponse.isValid))
    }
    
    func presentTimeOut(actionResponse: OrderPreviewModels.ExpirationValidations.ActionResponse) {
        viewController?.displayTimeOut(responseDisplay: .init(isTimedOut: actionResponse.isTimedOut))
    }
    
    func presentSubmit(actionResponse: OrderPreviewModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init(paymentReference: actionResponse.paymentReference))
    }
    
    // MARK: - Additional Helpers

}
