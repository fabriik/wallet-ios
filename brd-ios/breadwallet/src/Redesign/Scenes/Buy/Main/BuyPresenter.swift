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
        let sectionRows: [Models.Sections: [ViewModel]] = [
            .rate: [ExchangeRateViewModel()],
            .from: [SwapCurrencyViewModel(title: "I have")],
            .to: [CardSelectionViewModel()]
        ]
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentAmount(actionResponse: BuyModels.Amounts.ActionResponse) {
        guard let amount = actionResponse.amount else { return }
        let cryptoModel = SwapCurrencyViewModel(amount: amount, title: "From")
        let cardModel = CardSelectionViewModel()
        viewController?.displayAmount(actionResponse: .init(cryptoModel: cryptoModel, cardModel: cardModel))
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
    
    // MARK: - Additional Helpers

}
