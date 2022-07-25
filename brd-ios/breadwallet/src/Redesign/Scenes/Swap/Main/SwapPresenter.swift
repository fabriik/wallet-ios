//
//  SwapPresenter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class SwapPresenter: NSObject, Presenter, SwapActionResponses {
    
    typealias Models = SwapModels
    
    weak var viewController: SwapViewController?
    
    // MARK: - SwapActionResponses
    
    var exchangeRateViewModel = ExchangeRateViewModel()
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let from = item.from,
              let to = item.to
        else { return }
        
        let sections: [Models.Sections] = [
            .rateAndTimer,
            .swapCard,
            .amountSegment,
            .errors
        ]
        
        exchangeRateViewModel = ExchangeRateViewModel(quote: item.quote,
                                                      from: item.from?.code,
                                                      to: item.to?.code,
                                                      timer: TimerViewModel(till: item.quote?.timestamp ?? 0,
                                                                            repeats: false,
                                                                            finished: { [weak self] in
            self?.viewController?.interactor?.updateRate(viewAction: .init())
        }))
        
        
        // TODO: Get rid of empty values.
        let sectionRows: [Models.Sections: [Any]] = [
            .rateAndTimer: [
                exchangeRateViewModel
            ],
            .swapCard: [
                MainSwapViewModel(from: .init(amount: .zero(from), fee: .zero(from), title: "I have 0 \(from.code)"),
                                  to: .init(amount: .zero(to), fee: .zero(to), title: "I want"))
            ],
            .amountSegment: [
                SegmentControlViewModel(selectedIndex: nil)
            ],
            .errors: [
                InfoViewModel()
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentUpdateRate(actionResponse: SwapModels.Rate.ActionResponse) {
        exchangeRateViewModel = ExchangeRateViewModel(quote: actionResponse.quote,
                                                      from: actionResponse.from?.code,
                                                      to: actionResponse.to?.code,
                                                      timer: TimerViewModel(till: actionResponse.quote?.timestamp ?? 0,
                                                                            repeats: false,
                                                                            finished: { [weak self] in
            self?.viewController?.interactor?.updateRate(viewAction: .init())
        }))
                                                      
        viewController?.displayUpdateRate(responseDisplay: .init(rate: exchangeRateViewModel))
    }
    
    func presentSetAmount(actionResponse: SwapModels.Amounts.ActionResponse) {
        let balance = actionResponse.baseBalance
        let balanceText = "I have \(balance?.tokenValue.doubleValue ?? 0) \(balance?.currency.code ?? "BSV")"
        
        let swapModel = MainSwapViewModel(from: .init(amount: actionResponse.from,
                                                      fee: actionResponse.fromFee,
                                                      title: balanceText),
                                          to: .init(amount: actionResponse.to,
                                                    fee: actionResponse.toFee,
                                                    title: "I want"))
        
        exchangeRateViewModel.from = actionResponse.from?.currency.code
        exchangeRateViewModel.to = actionResponse.to?.currency.code

        viewController?.displaySetAmount(responseDisplay: .init(amounts: swapModel,
                                                                rate: exchangeRateViewModel,
                                                                minMaxToggleValue: .init(selectedIndex: actionResponse.minMaxToggleValue)))
        
        var hasError: Bool = actionResponse.from?.fiatValue == 0
        if actionResponse.baseBalance == nil
            || actionResponse.from?.currency.code == actionResponse.to?.currency.code {
            let first = actionResponse.from?.currency.code ?? "<base missing>"
            let second = actionResponse.to?.currency.code ?? "<term missing>"
            presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: "\(first)-\(second)")))
            hasError = true
        } else {
            let value = actionResponse.from?.fiatValue ?? 0
            let fromCrypto = actionResponse.from?.tokenValue ?? 0.0
            let profile = UserManager.shared.profile
            let dailyLimit = profile?.dailyRemainingLimit ?? 0
            let lifetimeLimit = profile?.lifetimeRemainingLimit ?? 0
            let exchangeLimit = profile?.exchangeLimit ?? 0
            let balance = actionResponse.baseBalance?.tokenValue ?? 0
            switch value {
            case _ where value <= 0:
                presentError(actionResponse: .init(error: nil))
                hasError = true
                
            case _ where value > (actionResponse.baseBalance?.fiatValue ?? 0):
                let error = SwapErrors.balanceTooLow(amount: fromCrypto, balance: balance, currency: actionResponse.from?.currency.code ?? "")
                presentError(actionResponse: .init(error: error))
                hasError = true
                
            case _ where value < 50:
                presentError(actionResponse: .init(error: SwapErrors.tooLow(amount: 50, currency: Store.state.defaultCurrencyCode)))
                hasError = true
                
            case _ where value > dailyLimit:
                presentError(actionResponse: .init(error: SwapErrors.overDailyLimit))
                hasError = true
                
            case _ where value > lifetimeLimit:
                presentError(actionResponse: .init(error: SwapErrors.overLifetimeLimit))
                hasError = true
                
            case _ where value > exchangeLimit:
                presentError(actionResponse: .init(error: SwapErrors.overExchangeLimit))
                hasError = true
                
            default:
                presentError(actionResponse: .init(error: nil))
            }
        }
        
        viewController?.displaySetAmount(responseDisplay: .init(continueEnabled: !hasError,
                                                                amounts: swapModel,
                                                                rate: exchangeRateViewModel,
                                                                minMaxToggleValue: .init(selectedIndex: actionResponse.minMaxToggleValue)))
    }
    
    func presentSelectAsset(actionResponse: SwapModels.Assets.ActionResponse) {
        viewController?.displaySelectAsset(responseDisplay: .init(from: actionResponse.from, to: actionResponse.to))
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
    
    func presentConfirmation(actionResponse: SwapModels.ShowConfirmDialog.ActionResponse) {
        guard let from = actionResponse.from,
              let fromFee = actionResponse.fromFee,
              let to = actionResponse.to,
              let toFee = actionResponse.toFee,
              let rate = actionResponse.quote?.closeAsk.doubleValue else {
            return
        }
        
        let fromText = String(format: "%.8f %@ (%.2f %@)", from.tokenValue.doubleValue, from.currency.code, from.fiatValue.doubleValue, Store.state.defaultCurrencyCode)
        let toText = String(format: "%.8f %@ (%.2f %@)", to.tokenValue.doubleValue, to.currency.code, to.fiatValue.doubleValue, Store.state.defaultCurrencyCode)
        let rateText = String(format: "1 %@ = %.8f %@", from.currency.code, rate, to.currency.code)
        let fromFeeText = String(format: "%.8f %@\n(%.2f) %@", fromFee.tokenValue.doubleValue,
                                 fromFee.currency.code,
                                 from.fiatValue.doubleValue,
                                 Store.state.defaultCurrencyCode)
        let toFeeText = String(format: "%.8f %@\n(%.2f) %@", toFee.tokenValue.doubleValue, toFee.currency.code, Store.state.defaultCurrencyCode)
        let totalCostText = String(format: "%.8f %@", from.tokenValue.doubleValue, from.currency.code)
        
        let config: WrapperPopupConfiguration<SwapConfimationConfiguration> = .init(wrappedView: .init())
        
        // TODO: localize
        let wrappedViewModel: SwapConfirmationViewModel = .init(from: .init(title: .text("From"), value: .text(fromText)),
                                                                to: .init(title: .text("To"), value: .text(toText)),
                                                                rate: .init(title: .text("Rate"), value: .text(rateText)),
                                                                sendingFee: .init(title: .text("Sending Network fee\n"), value: .text(fromFeeText)),
                                                                receivingFee: .init(title: .text("Receiving fee\n"), value: .text(toFeeText)),
                                                                totalCost: .init(title: .text("Total cost:"), value: .text(totalCostText)))
        
        let viewModel: WrapperPopupViewModel<SwapConfirmationViewModel> = .init(title: .text("Confirmation"),
                                                                                trailing: .init(image: "close"),
                                                                                confirm: .init(title: "Confirm"),
                                                                                cancel: .init(title: "Cancel"),
                                                                                wrappedView: wrappedViewModel)
        
        viewController?.displayConfirmation(responseDisplay: .init(config: config, viewModel: viewModel))
    }
    
    func presentConfirm(actionResponse: SwapModels.Confirm.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let exchangeId = actionResponse.exchangeId else {
            presentError(actionResponse: .init(error: GeneralError(errorMessage: "Not a valid pair")))
            return
        }
        viewController?.displayConfirm(responseDisplay: .init(from: from, to: to, exchangeId: "\(exchangeId)"))
    }
    
    // MARK: - Additional Helpers
}