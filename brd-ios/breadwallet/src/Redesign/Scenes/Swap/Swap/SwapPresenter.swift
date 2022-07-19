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
                                          bottomFeeString: bottomFeeString,
                                          shouldShowFees: validateFields(actionResponse))

        exchangeRateViewModel.firstCurrency = actionResponse.baseCurrency ?? ""
        exchangeRateViewModel.secondCurrency = actionResponse.termCurrency ?? ""

        viewController?.displaySetAmount(responseDisplay: .init(amounts: swapModel,
                                                                rate: exchangeRateViewModel,
                                                                minMaxToggleValue: .init(selectedIndex: actionResponse.minMaxToggleValue),
                                                                shouldEnableConfirm: validateFields(actionResponse)))
        
        guard actionResponse.baseCurrency != actionResponse.termCurrency else {
            let first = actionResponse.baseCurrency ?? "<base missing>"
            let second = actionResponse.termCurrency ?? "<term missing>"
            presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: "\(first)-\(second)")))
            return
        }
        
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
            
        case _ where value > actionResponse.baseBalance.fiatValue:
            presentError(actionResponse: .init(error: SwapErrors.balanceTooLow(amount: fromCrypto, balance: balance, currency: actionResponse.baseCurrency ?? "")))
            
        case _ where value < 50:
            presentError(actionResponse: .init(error: SwapErrors.tooLow(amount: 50, currency: "USD")))
            
        case _ where value > dailyLimit:
            presentError(actionResponse: .init(error: SwapErrors.overDailyLimit))
            
        case _ where value > lifetimeLimit:
            presentError(actionResponse: .init(error: SwapErrors.overLifetimeLimit))
            
        case _ where value > exchangeLimit:
            presentError(actionResponse: .init(error: SwapErrors.overExchangeLimit))
            
        default:
            presentError(actionResponse: .init(error: nil))
        }
    }
    
    func presentSelectAsset(actionResponse: SwapModels.Assets.ActionResponse) {
        viewController?.displaySelectAsset(responseDisplay: .init(from: actionResponse.from, to: actionResponse.to))
    }
    
    func presentError(actionResponse: MessageModels.Errors.ActionResponse) {
        guard let error = actionResponse.error as? SwapErrors else {
            viewController?.displayMessage(responseDisplay: .init(error: actionResponse.error as? FEError, model: nil, config: nil))
            return
        }
        
        let model = InfoViewModel(description: .text(error.errorMessage), dismissType: .persistent)
        let config = Presets.InfoView.swapError
        
        viewController?.displayMessage(responseDisplay: .init(model: model, config: config))
    }
    
    func presentConfirm(actionResponse: SwapModels.Confirm.ActionResponse) {
        viewController?.displayConfirm(responseDisplay: .init())
    }
    
    // MARK: - Additional Helpers
    
    private func validateFields(_ actionResponse: SwapModels.Amounts.ActionResponse) -> Bool {
        var fieldValidationIsAllowed = [String: Bool]()
        fieldValidationIsAllowed[String(describing: actionResponse.fromFiatAmount)] = actionResponse.fromFiatAmount ?? 0 > 0
        fieldValidationIsAllowed[String(describing: actionResponse.fromCryptoAmount)] = actionResponse.fromCryptoAmount ?? 0 > 0
        fieldValidationIsAllowed[String(describing: actionResponse.toFiatAmount)] = actionResponse.toFiatAmount ?? 0 > 0
        fieldValidationIsAllowed[String(describing: actionResponse.toCryptoAmount)] = actionResponse.toCryptoAmount ?? 0 > 0
        fieldValidationIsAllowed[String(describing: actionResponse.baseBalance)] = actionResponse.baseBalance.tokenValue > 0
        
        return fieldValidationIsAllowed.values.contains(where: { $0 == false }) == false
    }
}
