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
              let from = item.from?.currency,
              let to = item.to?.currency
        else {
            viewController?.displayError(responseDisplay: .init())
            return
        }
        
        let sections: [Models.Sections] = [
            .rateAndTimer,
            .accountLimits,
            .swapCard
        ]
        
        exchangeRateViewModel = ExchangeRateViewModel(timer: TimerViewModel())
        
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
                                              feeDescription: .text(L10n.Swap.sendNetworkFee)),
                                  to: .init(amount: .zero(to),
                                            fee: .zero(to),
                                            title: .text(L10n.Swap.iWant),
                                            feeDescription: .text(L10n.Swap.sendNetworkFee)))
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentExchangeRate(actionResponse: SwapModels.Rate.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let quote = actionResponse.quote else {
            return
        }
        
        let text = String(format: "1 %@ = %.5f %@", from.code, quote.exchangeRate.doubleValue, to.code)

        let minText = ExchangeFormatter.fiat.string(for: quote.minimumUsd) ?? ""
        let maxLimit = UserManager.shared.profile?.swapAllowanceDaily
        let maxText = ExchangeFormatter.fiat.string(for: maxLimit) ?? ""
        
        let limitText = String(format: L10n.Swap.swapLimits(minText, maxText))
        
        exchangeRateViewModel = ExchangeRateViewModel(exchangeRate: text,
                                                      timer: TimerViewModel(till: quote.timestamp,
                                                                            repeats: false),
                                                      showTimer: true)
        
        viewController?.displayExchangeRate(responseDisplay: .init(rate: exchangeRateViewModel,
                                                                   limits: .text(limitText)))
    }
    
    func presentAmount(actionResponse: SwapModels.Amounts.ActionResponse) {
        let balance = actionResponse.baseBalance
        let balanceText = String(format: L10n.Swap.balance(ExchangeFormatter.crypto.string(for: balance?.tokenValue.doubleValue) ?? "",
                                 balance?.currency.code ?? ""))
        let sendingFee = L10n.Swap.sendNetworkFeeNotIncluded
        let receivingFee = L10n.Swap.receiveNetworkFee
        
        let fromFiatValue = actionResponse.from?.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(for: actionResponse.from?.fiatValue)
        let fromTokenValue = actionResponse.from?.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(for: actionResponse.from?.tokenValue)
        let toFiatValue = actionResponse.to?.fiatValue == 0 ? nil : ExchangeFormatter.fiat.string(for: actionResponse.to?.fiatValue)
        let toTokenValue = actionResponse.to?.tokenValue == 0 ? nil : ExchangeFormatter.crypto.string(for: actionResponse.to?.tokenValue)
        
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
                                                    title: .text(L10n.Swap.iWant),
                                                    feeDescription: .text(receivingFee)))
        
        guard actionResponse.handleErrors else {
            viewController?.displayAmount(responseDisplay: .init(continueEnabled: false,
                                                                 amounts: swapModel,
                                                                 rate: exchangeRateViewModel))
            return
        }
        
        let minimumAmount: Decimal = actionResponse.minimumAmount ?? 5
        
        var hasError: Bool = actionResponse.from?.fiatValue == 0
        if actionResponse.baseBalance == nil
            || actionResponse.from?.currency.code == actionResponse.to?.currency.code {
            let first = actionResponse.from?.currency.code
            let second = actionResponse.to?.currency.code
            presentError(actionResponse: .init(error: SwapErrors.noQuote(from: first, to: second)))
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
                let limit = UserManager.shared.profile?.swapAllowanceDaily ?? 0
                let error = profile?.status == .levelTwo(.levelTwo) ? SwapErrors.overDailyLimitLevel2(limit: limit) : SwapErrors.overDailyLimit(limit: limit)
                presentError(actionResponse: .init(error: error))
                hasError = true
                
            case _ where value > lifetimeLimit:
                // over lifetime limit
                let limit = UserManager.shared.profile?.swapAllowanceLifetime ?? 0
                presentError(actionResponse: .init(error: SwapErrors.overLifetimeLimit(limit: limit)))
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
        
        let continueEnabled = (!hasError && actionResponse.fromFee != nil)
        
        viewController?.displayAmount(responseDisplay: .init(continueEnabled: continueEnabled,
                                                             amounts: swapModel,
                                                             rate: exchangeRateViewModel))
    }
    
    func presentSelectAsset(actionResponse: SwapModels.Assets.ActionResponse) {
        viewController?.displaySelectAsset(responseDisplay: .init(from: actionResponse.from, to: actionResponse.to))
    }
    
    func presentError(actionResponse: MessageModels.Errors.ActionResponse) {
        if let error = actionResponse.error as? SwapErrors,
           error.errorMessage == SwapErrors.selectAssets.errorMessage {
            presentAssetInfoPopup(actionResponse: .init())
            
        } else if let error = actionResponse.error as? FEError {
            let model = InfoViewModel(description: .text(error.errorMessage), dismissType: .persistent)
            let config = Presets.InfoView.swapError
            
            viewController?.displayMessage(responseDisplay: .init(error: error, model: model, config: config))
            
        } else {
            viewController?.displayMessage(responseDisplay: .init())
            
        }
    }
    
    func presentConfirmation(actionResponse: SwapModels.ShowConfirmDialog.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let rate = actionResponse.quote?.exchangeRate.doubleValue else {
            return
        }
        
        let rateText = String(format: "1 %@ = %@ %@", from.currency.code, ExchangeFormatter.fiat.string(for: rate) ?? "", to.currency.code)
        
        let fromText = String(format: "%@ %@ (%@ %@)", ExchangeFormatter.crypto.string(for: from.tokenValue.doubleValue) ?? "",
                              from.currency.code,
                              ExchangeFormatter.fiat.string(for: from.fiatValue.doubleValue) ?? "",
                              Store.state.defaultCurrencyCode)
        let toText = String(format: "%@ %@ (%@ %@)",
                            ExchangeFormatter.crypto.string(for: to.tokenValue.doubleValue) ?? "",
                            to.currency.code,
                            ExchangeFormatter.fiat.string(for: to.fiatValue.doubleValue) ?? "",
                            Store.state.defaultCurrencyCode)
        
        let fromFeeText = String(format: "%@ %@\n(%@) %@",
                                 ExchangeFormatter.crypto.string(for: actionResponse.fromFee?.tokenValue.doubleValue) ?? "",
                                 actionResponse.fromFee?.currency.code ?? from.currency.code,
                                 ExchangeFormatter.fiat.string(for: actionResponse.fromFee?.fiatValue.doubleValue) ?? "",
                                 Store.state.defaultCurrencyCode)
        
        let toFeeText = String(format: "%@ %@\n(%@) %@",
                               ExchangeFormatter.crypto.string(for: actionResponse.toFee?.tokenValue.doubleValue) ?? "",
                               actionResponse.toFee?.currency.code ?? to.currency.code,
                               ExchangeFormatter.fiat.string(for: actionResponse.toFee?.fiatValue.doubleValue) ?? "",
                               Store.state.defaultCurrencyCode)
        
        let totalCostText = String(format: "%@ %@", ExchangeFormatter.crypto.string(for: from.tokenValue.doubleValue) ?? "", from.currency.code)
        
        let config: WrapperPopupConfiguration<SwapConfimationConfiguration> = .init(wrappedView: .init())
        
        let wrappedViewModel: SwapConfirmationViewModel = .init(from: .init(title: .text(L10n.TransactionDetails.addressFromHeader), value: .text(fromText)),
                                                                to: .init(title: .text(L10n.TransactionDetails.addressToHeader), value: .text(toText)),
                                                                rate: .init(title: .text(L10n.Swap.rateValue), value: .text(rateText)),
                                                                sendingFee: .init(title: .text(L10n.Swap.sendingFee), value: .text(fromFeeText)),
                                                                receivingFee: .init(title: .text(L10n.Swap.receivingFee), value: .text(toFeeText)),
                                                                totalCost: .init(title: .text(L10n.Confirmation.totalLabel), value: .text(totalCostText)))
        
        let viewModel: WrapperPopupViewModel<SwapConfirmationViewModel> = .init(title: .text(L10n.Confirmation.title),
                                                                                confirm: .init(title: L10n.Button.confirm),
                                                                                cancel: .init(title: L10n.Button.cancel),
                                                                                wrappedView: wrappedViewModel)
        
        viewController?.displayConfirmation(responseDisplay: .init(config: config, viewModel: viewModel))
    }
    
    func presentConfirm(actionResponse: SwapModels.Confirm.ActionResponse) {
        guard let from = actionResponse.from,
              let to = actionResponse.to,
              let exchangeId = actionResponse.exchangeId else {
                  presentError(actionResponse: .init(error: GeneralError(errorMessage: L10n.Swap.notValidPair)))
            return
        }
        viewController?.displayConfirm(responseDisplay: .init(from: from, to: to, exchangeId: "\(exchangeId)"))
    }
    
    func presentAssetInfoPopup(actionResponse: SwapModels.AssetInfoPopup.ActionResponse) {
        let popupViewModel = PopupViewModel(title: .text(L10n.Swap.checkAssets),
                                            body: L10n.Swap.checkAssetsBody,
                                            buttons: [.init(title: L10n.Swap.gotItButton)])
        
        viewController?.displayAssetInfoPopup(responseDisplay: .init(popupViewModel: popupViewModel,
                                                                     popupConfig: Presets.Popup.white))
    }
    
    // MARK: - Additional Helpers
}
