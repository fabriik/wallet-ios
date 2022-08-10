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
            .from,
            .to,
            .error
        ]
        
        // TODO: Localize

        let sectionRows: [Models.Sections: [ViewModel]] =  [
            .rate: [ExchangeRateViewModel()],
            .from: [SwapCurrencyViewModel(title: "I want")],
            .to: [CardSelectionViewModel(userInteractionEnabled: true)]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    func presentExchangeRate(actionResponse: BuyModels.Rate.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let rate = actionResponse.rate else {
            return
        }
        
        let text = String(format: "1 %@ = %.1f %@", from.uppercased(), rate.doubleValue, to.uppercased())
        
        let model = ExchangeRateViewModel(exchangeRate: text,
                                            timer: TimerViewModel(till: (actionResponse.expires ?? 0) * 1000,
                                                                  repeats: false))
        
        viewController?.displayExchangeRate(responseDisplay: model)
    }
    
    func presentAssets(actionResponse: BuyModels.Assets.ActionResponse) {
        let cryptoModel: SwapCurrencyViewModel
        let cardModel: CardSelectionViewModel
        
        // TODO: Localize
        if let amount = actionResponse.amount {
            cryptoModel = .init(amount: amount, title: "I want")
        } else {
            cryptoModel = .init(title: "I want")
        }
        
        if let paymentCard = actionResponse.card {
            cardModel = .init(logo: paymentCard.displayImage,
                              cardNumber: .text(paymentCard.displayName),
                              expiration: .text(CardDetailsFormatter.formatExpirationDate(month: paymentCard.expiryMonth, year: paymentCard.expiryYear)),
                              userInteractionEnabled: true)
        } else {
            cardModel = .init(userInteractionEnabled: true)
        }
        
        viewController?.displayAssets(actionResponse: .init(cryptoModel: cryptoModel, cardModel: cardModel))
    }
    
    // MARK: - Additional Helpers

}
