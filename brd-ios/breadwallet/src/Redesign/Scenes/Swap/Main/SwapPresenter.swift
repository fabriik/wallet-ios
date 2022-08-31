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
    
    private var exchangeRateViewModel = ExchangeRateViewModel()
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let from = item.from,
              let to = item.to
        else {
            viewController?.displayError(responseDisplay: .init())
            return
        }
        
        let sections: [Models.Sections] = [
            .rateAndTimer,
            .accountLimits,
            .swapCard
        ]
        
        exchangeRateViewModel = ExchangeRateViewModel(timer: TimerViewModel(till: item.quote?.timestamp ?? 0,
                                                                            repeats: false))
        
        // TODO: Localize
        let sectionRows: [Models.Sections: [Any]] = [
            .rateAndTimer: [
                exchangeRateViewModel
            ],
            .accountLimits: [
                LabelViewModel.text("")
            ],
            .swapCard: [
                MainSwapViewModel(from: .init(amount: .zero(from),
                                              fee: .zero(from),
                                              title: .text("I have 0 \(from.code)"),
                                              feeDescription: .text("Sending network fee\n(included)")),
                                  to: .init(amount: .zero(to),
                                            fee: .zero(to),
                                            title: .text("I want"),
                                            feeDescription: .text("Sending network fee\n(included)")))
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentRate(actionResponse: SwapModels.Rate.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let quote = actionResponse.quote else {
            return
        }
        
        let text = String(format: "1 %@ = %.5f %@", from.code, quote.exchangeRate.doubleValue, to.code)

        let minText = ExchangeFormatter.fiat.string(for: quote.minimumUsd) ?? ""
        let maxText = ExchangeFormatter.fiat.string(for: quote.maximumUsd) ?? ""
        let limitText = String(format: "Currently, minimum limit for swap is $%@ USD and maximum limit is %@ USD/day.", minText, maxText)
        
        exchangeRateViewModel = ExchangeRateViewModel(exchangeRate: text,
                                                      timer: TimerViewModel(till: quote.timestamp,
                                                                            repeats: false,
                                                                            isVisible: true))
        
        viewController?.displayRate(responseDisplay: .init(rate: exchangeRateViewModel,
                                                           limits: .text(limitText)))
    }
    
    func presentAmount(actionResponse: SwapModels.Amounts.ActionResponse) {
        let balance = actionResponse.baseBalance
        let balanceText = String(format: "I have %.4f %@", balance?.tokenValue.doubleValue ?? 0, balance?.currency.code ?? "BSV")
        let sendingFee = "Sending network fee\n(not included)"
        let receivingFee = "Receiving network fee\n(included)"
        
        let fromFiatValue = actionResponse.from?.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(from: (actionResponse.from?.fiatValue ?? 0) as NSNumber)
        let fromTokenValue = actionResponse.from?.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(from: (actionResponse.from?.tokenValue ?? 0) as NSNumber)
        let toFiatValue = actionResponse.to?.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(from: (actionResponse.to?.fiatValue ?? 0) as NSNumber)
        let toTokenValue = actionResponse.to?.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(from: (actionResponse.to?.tokenValue ?? 0) as NSNumber)
        
        let fromFormattedFiatString = ExchangeFormatter.createAmountString(string: fromFiatValue ?? "")
        let fromFormattedTokenString = ExchangeFormatter.createAmountString(string: fromTokenValue ?? "")
        let toFormattedFiatString = ExchangeFormatter.createAmountString(string: toFiatValue ?? "")
        let toFormattedTokenString = ExchangeFormatter.createAmountString(string: toTokenValue ?? "")
        
        let swapModel = MainSwapViewModel(from: .init(amount: actionResponse.from,
                                                      formattedFiatString: fromFormattedFiatString,
                                                      formattedTokenString: fromFormattedTokenString,
                                                      fee: actionResponse.fromFee,
                                                      title: .text(balanceText),
                                                      feeDescription: .text(sendingFee)),
                                          to: .init(amount: actionResponse.to,
                                                    formattedFiatString: toFormattedFiatString,
                                                    formattedTokenString: toFormattedTokenString,
                                                    fee: actionResponse.toFee,
                                                    title: .text("I want"),
                                                    feeDescription: .text(receivingFee)))
        
        let minimumAmount: Decimal = actionResponse.minimumAmount ?? 5
        
        var hasError: Bool = actionResponse.from?.fiatValue == 0
        if actionResponse.baseBalance == nil
            || actionResponse.from?.currency.code == actionResponse.to?.currency.code {
            let first = actionResponse.from?.currency.code ?? "<base missing>"
            let second = actionResponse.to?.currency.code ?? "<term missing>"
            presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: "\(first)-\(second)")))
            hasError = true
        } else if TransferManager.shared.canSwap(actionResponse.from?.currency) == false {
            presentError(actionResponse: .init(error: SwapErrors.pendingSwap))
            hasError = true
        } else {
            let value = actionResponse.from?.fiatValue ?? 0
            let profile = UserManager.shared.profile
            let dailyLimit = profile?.swapDailyRemainingLimit ?? 0
            let lifetimeLimit = profile?.swapLifetimeRemainingLimit ?? 0
            let exchangeLimit = profile?.swapAllowancePerExchange    ?? 0
            let balance = actionResponse.baseBalance?.tokenValue ?? 0
            
            switch value {
            case _ where value <= 0:
                // fiat value is bellow 0
                presentError(actionResponse: .init(error: nil))
                hasError = true
                
            case _ where value > (actionResponse.baseBalance?.fiatValue ?? 0):
                // value higher than balance
                let error = SwapErrors.balanceTooLow(balance: balance, currency: actionResponse.from?.currency.code ?? "")
                presentError(actionResponse: .init(error: error))
                hasError = true
                
            case _ where value < minimumAmount:
                // value bellow minimum fiat
                presentError(actionResponse: .init(error: SwapErrors.tooLow(amount: minimumAmount, currency: Store.state.defaultCurrencyCode)))
                hasError = true
                
            case _ where value > dailyLimit:
                // over daily limit
                let error = profile?.status == .levelTwo(.levelTwo) ? SwapErrors.overDailyLimitLevel2 : SwapErrors.overDailyLimit
                presentError(actionResponse: .init(error: error))
                hasError = true
                
            case _ where value > lifetimeLimit:
                // over lifetime limit
                presentError(actionResponse: .init(error: SwapErrors.overLifetimeLimit))
                hasError = true
                
            case _ where value > exchangeLimit:
                // over exchange limit ???
                presentError(actionResponse: .init(error: SwapErrors.overExchangeLimit))
                hasError = true
                
            default:
                // remove error
                presentError(actionResponse: .init(error: nil))
            }
        }
        
        viewController?.displayAmount(responseDisplay: .init(continueEnabled: !hasError,
                                                             amounts: swapModel,
                                                             rate: exchangeRateViewModel))
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
              let to = actionResponse.to,
              let rate = actionResponse.quote?.exchangeRate.doubleValue else {
            return
        }
        
        let fromText = String(format: "%.8f %@ (%.2f %@)", from.tokenValue.doubleValue, from.currency.code, from.fiatValue.doubleValue, Store.state.defaultCurrencyCode)
        let toText = String(format: "%.8f %@ (%.2f %@)", to.tokenValue.doubleValue, to.currency.code, to.fiatValue.doubleValue, Store.state.defaultCurrencyCode)
        let rateText = String(format: "1 %@ = %.5f %@", from.currency.code, rate, to.currency.code)
        
        let fromFeeText = String(format: "%.8f %@\n(%.8f) %@",
                                 actionResponse.fromFee?.tokenValue.doubleValue ?? 0,
                                 actionResponse.fromFee?.currency.code ?? from.currency.code,
                                 actionResponse.fromFee?.fiatValue.doubleValue ?? 0,
                                 Store.state.defaultCurrencyCode)
        let toFeeText = String(format: "%.8f %@\n(%.8f) %@",
                               actionResponse.toFee?.tokenValue.doubleValue ?? 0,
                               actionResponse.toFee?.currency.code ?? to.currency.code,
                               actionResponse.toFee?.fiatValue.doubleValue ?? 0,
                               Store.state.defaultCurrencyCode)
        
        let totalCostText = String(format: "%.8f %@", from.tokenValue.doubleValue, from.currency.code)
        
        let config: WrapperPopupConfiguration<SwapConfimationConfiguration> = .init(wrappedView: .init())
        
        // TODO: localize
        let wrappedViewModel: SwapConfirmationViewModel = .init(from: .init(title: .text("From"), value: .text(fromText)),
                                                                to: .init(title: .text("To"), value: .text(toText)),
                                                                rate: .init(title: .text("Rate"), value: .text(rateText)),
                                                                sendingFee: .init(title: .text("Sending fee\n"), value: .text(fromFeeText)),
                                                                receivingFee: .init(title: .text("Receiving fee\n"), value: .text(toFeeText)),
                                                                totalCost: .init(title: .text("Total cost:"), value: .text(totalCostText)))
        
        let viewModel: WrapperPopupViewModel<SwapConfirmationViewModel> = .init(title: .text("Confirmation"),
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
    
    func presentInfoPopup(actionResponse: SwapModels.InfoPopup.ActionResponse) {
        // TODO: Localize.
        let popupViewModel = PopupViewModel(title: .text("Check your assets!"),
                                            body: """
In order to succesfully perform a swap, make sure you have two or more of our supported swap assets (BSV, BTC, ETH, BCH, SHIB, USDT) activated and funded within your wallet.
""",
                                            buttons: [.init(title: "Got it!")])
        
        viewController?.displayInfoPopup(responseDisplay: .init(popupViewModel: popupViewModel,
                                                                popupConfig: Presets.Popup.white))
    }
    
    // MARK: - Additional Helpers
}
