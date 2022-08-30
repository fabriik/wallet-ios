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
              let card = item.card else { return }
        
        let to = toAmount.fiatValue
        let infoImage = UIImage(named: "help")?.withRenderingMode(.alwaysOriginal)
        let toFiatValue = toAmount.fiatValue
        let toCryptoValue = toAmount.tokenFormattedString
        let toCryptoDisplayImage = item.to?.currency.imageSquareBackground
        let toCryptoDisplayName = item.to?.currency.displayName ?? ""
        let from = item.from ?? 0
        let cardFee = from * (quote.buyFee ?? 0) / 100
        let networkFee = item.networkFee?.fiatValue ?? 0
        let fiatCurrency = (quote.fromFeeCurrency?.feeCurrency ?? C.usdCurrencyCode).uppercased()
        
        let currencyFormat = "%@ %@"
        let amountText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: to) ?? "", fiatCurrency)
        let cardFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: cardFee) ?? "", fiatCurrency)
        let networkFeeText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: networkFee) ?? "", fiatCurrency)
        
        let rate = String(format: "1 %@ = %@ %@", toAmount.currency.code, ExchangeFormatter.fiat.string(for: 1 / quote.exchangeRate) ?? "", fiatCurrency)
        let totalText = String(format: currencyFormat, ExchangeFormatter.fiat.string(for: toFiatValue + networkFee + cardFee) ?? "", fiatCurrency)
        let wrappedViewModel: BuyOrderViewModel = .init(currencyIcon: .image(toCryptoDisplayImage),
                                                        currencyAmountName: .text(toCryptoValue + " " + toCryptoDisplayName),
                                                        rate: .init(exchangeRate: rate, timer: nil),
                                                        amount: .init(title: .text("Amount purchased"), value: .text(amountText), infoImage: nil),
                                                        cardFee: .init(title: .text("Card fee (\(quote.buyFee ?? 0)%)"),
                                                                       value: .text(cardFeeText),
                                                                       infoImage: .image(infoImage)),
                                                        networkFee: .init(title: .text("Mining network fee"), value: .text(networkFeeText), infoImage: .image(infoImage)),
                                                        totalCost: .init(title: .text("Total:"), value: .text(totalText)))
        
        let termsText = NSMutableAttributedString(string: "By placing this order you agree to our" + " ")
        termsText.addAttribute(NSAttributedString.Key.font,
                               value: Fonts.caption,
                               range: NSRange(location: 0, length: termsText.length))
        termsText.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: LightColors.Text.two,
                               range: NSRange(location: 0, length: termsText.length))
        
        let interactableText = NSMutableAttributedString(string: "Terms and Conditions")
        interactableText.addAttribute(NSAttributedString.Key.font,
                                      value: Fonts.caption,
                                      range: NSRange(location: 0, length: interactableText.length))
        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: LightColors.primary,
            NSAttributedString.Key.underlineColor: LightColors.primary,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        interactableText.addAttributes(linkAttributes, range: NSRange(location: 0, length: interactableText.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        termsText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: termsText.length))
        
        termsText.append(interactableText)
        
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
                LabelViewModel.attributedText(termsText)
            ],
            .submit: [
                ButtonViewModel(title: "Confirm", enabled: false)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentInfoPopup(actionResponse: OrderPreviewModels.InfoPopup.ActionResponse) {
        let model: PopupViewModel
        
        if actionResponse.isCardFee {
            let feeText = "This fee is charged to cover costs associated with payment processing."
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
    
    func presentTermsAndConditions(actionResponse: OrderPreviewModels.TermsAndConditions.ActionResponse) {
        viewController?.displayTermsAndConditions(responseDisplay: .init(url: actionResponse.url))
    }
    
    func presentSubmit(actionResponse: OrderPreviewModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init(paymentReference: actionResponse.paymentReference))
    }
    
    // MARK: - Additional Helpers

}
