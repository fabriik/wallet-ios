//
//  BuyPresenter.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

final class BuyPresenter: NSObject, Presenter, BuyActionResponses {
    typealias Models = BuyModels

    weak var viewController: BuyViewController?

    // MARK: - BuyActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let sections: [Models.Sections] = [
            .rate,
            .accountLimits,
            .from,
            .to,
            .error
        ]
        
        // TODO: Localize

        let sectionRows: [Models.Sections: [ViewModel]] =  [
            .rate: [ExchangeRateViewModel()],
            .accountLimits: [
                LabelViewModel.text("")
            ],
            .from: [SwapCurrencyViewModel(title: .text("I want"))],
            .to: [CardSelectionViewModel(userInteractionEnabled: true)]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    func presentExchangeRate(actionResponse: BuyModels.Rate.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let quote = actionResponse.quote else {
            return
        }
        
        let text = String(format: "1 %@ = %@ %@", to.uppercased(), ExchangeFormatter.fiat.string(for: 1 / quote.exchangeRate) ?? "/", from.uppercased())
        let min = ExchangeFormatter.fiat.string(for: quote.minimumValue) ?? ""
        let max = ExchangeFormatter.fiat.string(for: quote.maximumValue) ?? ""
        let limitText = String(format: "Currently, minimum limit for swap is $%@ USD and maximum limit is %@ USD/day.", min, max)
        
        let model = ExchangeRateViewModel(exchangeRate: text,
                                          timer: TimerViewModel(till: quote.timestamp,
                                                                repeats: false,
                                                                isVisible: false))
        
        viewController?.displayExchangeRate(responseDisplay: .init(rate: model,
                                                                   limits: .text(limitText)))
    }
    
    func presentAssets(actionResponse: BuyModels.Assets.ActionResponse) {
        let cryptoModel: SwapCurrencyViewModel
        let cardModel: CardSelectionViewModel
        
        let fromFiatValue = actionResponse.amount?.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(for: actionResponse.amount?.fiatValue ?? 0)
        let fromTokenValue = actionResponse.amount?.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(from: (actionResponse.amount?.tokenValue ?? 0) as NSNumber)
        
        let formattedFiatString = ExchangeFormatter.createAmountString(string: fromFiatValue ?? "")
        let formattedTokenString = ExchangeFormatter.createAmountString(string: fromTokenValue ?? "")
        
        // TODO: Localize
        cryptoModel = .init(amount: actionResponse.amount,
                            formattedFiatString: formattedFiatString,
                            formattedTokenString: formattedTokenString,
                            title: .text("I want"))
        
        if let paymentCard = actionResponse.card {
            cardModel = .init(logo: paymentCard.displayImage,
                              cardNumber: .text(paymentCard.displayName),
                              expiration: .text(CardDetailsFormatter.formatExpirationDate(month: paymentCard.expiryMonth, year: paymentCard.expiryYear)),
                              userInteractionEnabled: true)
        } else {
            cardModel = .init(userInteractionEnabled: true)
        }
        
        let fiat = actionResponse.amount?.fiatValue ?? 0
        let profile = UserManager.shared.profile
        let dailyLimit = profile?.buyDailyRemainingLimit ?? 0
        let lifetimeLimit = profile?.buyLifetimeRemainingLimit ?? 0
        let exchangeLimit = profile?.buyAllowancePerPurchase    ?? 0
        let minimumAmount = actionResponse.quote?.minimumUsd ?? 0
        let maximumAmount = actionResponse.quote?.maximumUsd ?? 0
        
        switch fiat {
        case _ where fiat <= 0:
            // fiat value is bellow 0
            presentError(actionResponse: .init(error: nil))
            
        case _ where minimumAmount > maximumAmount:
            presentError(actionResponse: .init(error: BuyErrors.notPermitted))
            
        case _ where fiat < minimumAmount:
            // value bellow minimum fiat
            presentError(actionResponse: .init(error: BuyErrors.tooLow(amount: minimumAmount, currency: Store.state.defaultCurrencyCode)))
            
        case _ where fiat > maximumAmount:
            // over exchange limit ???
            presentError(actionResponse: .init(error: BuyErrors.tooHigh(amount: maximumAmount, currency: C.usdCurrencyCode)))
            
        case _ where fiat > dailyLimit:
            // over daily limit
            presentError(actionResponse: .init(error: BuyErrors.overDailyLimit))
            
        case _ where fiat > lifetimeLimit:
            // over lifetime limit
            presentError(actionResponse: .init(error: BuyErrors.overLifetimeLimit))
            
        case _ where fiat > exchangeLimit:
            // over exchange limit ???
            presentError(actionResponse: .init(error: BuyErrors.overExchangeLimit))
            
        default:
            // remove error
            presentError(actionResponse: .init(error: nil))
        }
        
        viewController?.displayAssets(responseDisplay: .init(cryptoModel: cryptoModel, cardModel: cardModel))
    }
    
    func presentPaymentCards(actionResponse: BuyModels.PaymentCards.ActionResponse) {
        viewController?.displayPaymentCards(responseDisplay: .init(allPaymentCards: actionResponse.allPaymentCards))
    }
    
    func presentOrderPreview(actionResponse: BuyModels.OrderPreview.ActionResponse) {
        viewController?.displayOrderPreview(responseDisplay: .init())
    }
    
    func presentError(actionResponse: MessageModels.Errors.ActionResponse) {
        guard let error = actionResponse.error as? FEError else {
            viewController?.displayMessage(responseDisplay: .init())
            return
        }
        
        let model = InfoViewModel(description: .text(error.errorMessage), dismissType: .persistent)
        let config = Presets.InfoView.swapError
        
        viewController?.displayMessage(responseDisplay: .init(error: error, model: model, config: config))
    }
    
    // MARK: - Additional Helpers

}
