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
        let sections: [Models.Sections] = [
            .rateAndTimer,
            .swapCard,
            .amountSegment,
            .errors
        ]
        
        // TODO: Get rid of empty values.
        let sectionRows: [Models.Sections: [Any]] = [
            .rateAndTimer: [
                ExchangeRateViewModel()
            ],
            .swapCard: [
                MainSwapViewModel()
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
        exchangeRateViewModel = ExchangeRateViewModel(firstCurrency: actionResponse.baseCurrency ?? "",
                                                      secondCurrency: actionResponse.termCurrency ?? "",
                                                      exchangeRate: String(format: "%.5f", NSDecimalNumber(decimal: actionResponse.baseRate).doubleValue),
                                                      timer: TimerViewModel(till: actionResponse.rateTimeStamp,
                                                                            repeats: false,
                                                                            finished: { [weak self] in
            self?.viewController?.interactor?.updateRate(viewAction: .init())
        }))
                                                      
        viewController?.displayUpdateRate(responseDisplay: .init(rate: exchangeRateViewModel))
    }
    
    func presentSetAmount(actionResponse: SwapModels.Amounts.ActionResponse) {
        let format = "%.*f"
        let decimal = 10

        let formattedBaseCryptoString = String(format: format, decimal, actionResponse.fromBaseCryptoFee?.doubleValue ?? 0)
        let baseCurrencyString = " " + (actionResponse.baseCurrency ?? "")
        let formattedBaseFiatString = "\n" + String(format: format, decimal, actionResponse.fromBaseFiatFee?.doubleValue ?? 0)

        let formattedTermCryptoString = String(format: format, decimal, actionResponse.fromTermCryptoFee?.doubleValue ?? 0)
        let termCurrencyString = " " + (actionResponse.termCurrency ?? "")
        let formattedTermFiatString = "\n" + String(format: format, decimal, actionResponse.fromTermFiatFee?.doubleValue ?? 0)

        let defaultCurrencyCodeString = " " + Store.state.defaultCurrencyCode

        let topFeeString: String = formattedBaseCryptoString + baseCurrencyString + formattedBaseFiatString + defaultCurrencyCodeString
        let bottomFeeString: String = formattedTermCryptoString + termCurrencyString + formattedTermFiatString + defaultCurrencyCodeString

        let swapModel = MainSwapViewModel(selectedBaseCurrency: actionResponse.baseCurrency ?? "",
                                          selectedBaseCurrencyIcon: actionResponse.baseCurrencyIcon,
                                          selectedTermCurrency: actionResponse.termCurrency ?? "",
                                          selectedTermCurrencyIcon: actionResponse.termCurrencyIcon,
                                          fromFiatAmount: actionResponse.fromFiatAmount,
                                          fromFiatAmountString: "\(actionResponse.fromFiatAmount?.doubleValue ?? 0.00)",
                                          fromCryptoAmount: actionResponse.fromCryptoAmount,
                                          fromCryptoAmountString: "\(actionResponse.fromCryptoAmount?.doubleValue ?? 0.00)",
                                          toFiatAmount: actionResponse.toFiatAmount,
                                          toFiatAmountString: "\(actionResponse.toFiatAmount?.doubleValue ?? 0.00)",
                                          toCryptoAmount: actionResponse.toCryptoAmount,
                                          toCryptoAmountString: "\(actionResponse.toCryptoAmount?.doubleValue ?? 0.00)",
                                          balanceString: actionResponse.baseBalance.tokenFormattedString + " " + actionResponse.baseBalance.currency.code.uppercased(),
                                          topFeeString: topFeeString,
                                          bottomFeeString: bottomFeeString)

        exchangeRateViewModel.firstCurrency = actionResponse.baseCurrency ?? ""
        exchangeRateViewModel.secondCurrency = actionResponse.termCurrency ?? ""

        viewController?.displaySetAmount(responseDisplay: .init(amounts: swapModel,
                                                                rate: exchangeRateViewModel,
                                                                minMaxToggleValue: .init(selectedIndex: actionResponse.minMaxToggleValue)))
        
        var hasError: Bool = actionResponse.fromFiatAmount == 0
        if actionResponse.baseCurrency == actionResponse.termCurrency {
            let first = actionResponse.baseCurrency ?? "<base missing>"
            let second = actionResponse.termCurrency ?? "<term missing>"
            presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: "\(first)-\(second)")))
            hasError = true
        } else {
            let value = actionResponse.fromFiatAmount ?? 0
            let fromCrypto = actionResponse.fromCryptoAmount ?? 0.0
            let profile = UserManager.shared.profile
            let dailyLimit = profile?.dailyRemainingLimit ?? 0
            let lifetimeLimit = profile?.lifetimeRemainingLimit ?? 0
            let exchangeLimit = profile?.exchangeLimit ?? 0
            let balance = actionResponse.baseBalance.tokenValue
            switch value {
            case _ where value <= 0:
                presentError(actionResponse: .init(error: nil))
                hasError = true
                
            case _ where value > actionResponse.baseBalance.fiatValue:
                presentError(actionResponse: .init(error: SwapErrors.balanceTooLow(amount: fromCrypto, balance: balance, currency: actionResponse.baseCurrency ?? "")))
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
        guard let from = actionResponse.from?.doubleValue,
              let fromFiat = actionResponse.fromFiat?.doubleValue,
              let fromCurrency = actionResponse.fromCurrency,
              let fromFee = actionResponse.fromFee?.doubleValue,
              let fromFiatFee = actionResponse.fromFiatFee?.doubleValue,
              let to = actionResponse.to?.doubleValue,
              let toFiat = actionResponse.toFiat?.doubleValue,
              let toCurrency = actionResponse.toCurrency,
              let toFee = actionResponse.toFee?.doubleValue,
              let toFiatFee = actionResponse.toFiatFee?.doubleValue,
              let rate = actionResponse.quote?.closeAsk.doubleValue else {
            return
        }
              
        let fromText = String(format: "%.8f %@ (%.2f %@)", from, fromCurrency, fromFiat, Store.state.defaultCurrencyCode)
        let toText = String(format: "%.8f %@ (%.2f %@)", to, toCurrency, toFiat, Store.state.defaultCurrencyCode)
        let rateText = String(format: "1 %@ = %.8f %@", fromCurrency, rate, toCurrency)
        
        let fromFeeText = String(format: "%.8f %@\n(%.2f) %@", fromFee, fromCurrency, fromFiatFee, Store.state.defaultCurrencyCode)
        let toFeeText = String(format: "%.8f %@\n(%.2f) %@", toFee, toCurrency, toFiatFee, Store.state.defaultCurrencyCode)
        let totalCostText = String(format: "%.8f %@", from, fromCurrency)
        
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
        viewController?.displayConfirm(responseDisplay: .init(from: from, to: to, exchangeId: exchangeId))
    }
    
    // MARK: - Additional Helpers
}
