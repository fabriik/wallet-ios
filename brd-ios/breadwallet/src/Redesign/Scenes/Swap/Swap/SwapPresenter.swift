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
    
    private var mainSwapModel: MainSwapViewModel = .init(selectedBaseCurrency: "", selectedTermCurrency: "", balanceString: "")
    private var exchangeRateViewModel: ExchangeRateViewModel = .init(firstCurrency: "", secondCurrency: "")
    
    // MARK: - SwapActionResponses
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let sections: [Models.Sections] = [
            .rateAndTimer,
            .swapCard,
            .amountSegment
        ]
        
        let sectionRows: [Models.Sections: [Any]] = [
            .rateAndTimer: [
                exchangeRateViewModel
            ],
            .swapCard: [
                mainSwapModel
            ],
            .amountSegment: [
                SegmentControlViewModel(selectedIndex: nil)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentUpdateRate(actionResponse: SwapModels.Rate.ActionResponse) {
        exchangeRateViewModel.exchangeRate = String(format: "%.5f", NSDecimalNumber(decimal: actionResponse.baseRate).doubleValue)
        exchangeRateViewModel.timer = TimerViewModel(till: actionResponse.rateTimeStamp,
                                                     repeats: false,
                                                     finished: { [weak self] in
            self?.viewController?.interactor?.updateRate(viewAction: .init())
        })
        
        viewController?.displayUpdateRate(responseDisplay: .init(rate: exchangeRateViewModel))
    }
    
    func presentSetAmount(actionResponse: SwapModels.Amounts.ActionResponse) {
        mainSwapModel.fromFiatAmount = actionResponse.fromFiatAmount
        mainSwapModel.fromFiatAmountString = "\(actionResponse.fromFiatAmount?.doubleValue ?? 0.00)"
        
        mainSwapModel.fromCryptoAmount = actionResponse.fromCryptoAmount
        mainSwapModel.fromCryptoAmountString = "\(actionResponse.fromCryptoAmount?.doubleValue ?? 0.00)"
        
        mainSwapModel.toFiatAmount = actionResponse.toFiatAmount
        mainSwapModel.toFiatAmountString = "\(actionResponse.toFiatAmount?.doubleValue ?? 0.00)"
        
        mainSwapModel.toCryptoAmount = actionResponse.toCryptoAmount
        mainSwapModel.toCryptoAmountString = "\(actionResponse.toCryptoAmount?.doubleValue ?? 0.00)"
        
        mainSwapModel.selectedBaseCurrency = actionResponse.baseCurrency ?? ""
        mainSwapModel.selectedBaseCurrencyIcon = actionResponse.baseCurrencyIcon
        mainSwapModel.selectedTermCurrency = actionResponse.termCurrency ?? ""
        mainSwapModel.selectedTermCurrencyIcon = actionResponse.termCurrencyIcon
        mainSwapModel.balanceString = actionResponse.baseBalance.tokenFormattedString + " " + actionResponse.baseBalance.currency.code.uppercased()
        
        mainSwapModel.shouldShowFees = validateFields(actionResponse)
        
        let format = "%.*f"
        let decimal = 10
        mainSwapModel.topFeeString = String(format: format, decimal, actionResponse.fromBaseCryptoFee?.doubleValue ?? 0)
        + " " + (mainSwapModel.selectedBaseCurrency)
        + "\n" + String(format: format, decimal, actionResponse.fromBaseFiatFee?.doubleValue ?? 0)
        + " " + Store.state.defaultCurrencyCode
        
        mainSwapModel.bottomFeeString = String(format: format, decimal, actionResponse.fromTermCryptoFee?.doubleValue ?? 0)
        + " " + (mainSwapModel.selectedTermCurrency)
        + "\n" + String(format: format, decimal, actionResponse.fromTermFiatFee?.doubleValue ?? 0)
        + " " + Store.state.defaultCurrencyCode
        
        exchangeRateViewModel.firstCurrency = actionResponse.baseCurrency ?? ""
        exchangeRateViewModel.secondCurrency = actionResponse.termCurrency ?? ""
        
        viewController?.displaySetAmount(responseDisplay: .init(amounts: mainSwapModel,
                                                                rate: exchangeRateViewModel,
                                                                minMaxToggleValue: .init(selectedIndex: actionResponse.minMaxToggleValue),
                                                                shouldEnableConfirm: validateFields(actionResponse)))
    }
    
    func presentSelectAsset(actionResponse: SwapModels.Assets.ActionResponse) {
        viewController?.displaySelectAsset(responseDisplay: .init(from: actionResponse.from, to: actionResponse.to))
    }
    
    // MARK: - Additional Helpers
    
    private func validateFields(_ actionResponse: SwapModels.Amounts.ActionResponse) -> Bool {
        var fieldValidationIsAllowed = [String?: Bool]()
        fieldValidationIsAllowed["fromFiatAmount"] = actionResponse.fromFiatAmountString?.isEmpty == true
        fieldValidationIsAllowed["fromCryptoAmount"] = actionResponse.fromCryptoAmountString?.isEmpty == true
        fieldValidationIsAllowed["toFiatAmount"] = actionResponse.toFiatAmountString?.isEmpty == true
        fieldValidationIsAllowed["toCryptoAmount"] = actionResponse.toCryptoAmountString?.isEmpty == true
        return fieldValidationIsAllowed.values.contains(where: { $0 == true }) == false
    }
}
