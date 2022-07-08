//
//  SwapInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class SwapInteractor: NSObject, Interactor, SwapViewActions {
    
    typealias Models = SwapModels
    
    var presenter: SwapPresenter?
    var dataStore: SwapStore?

    // MARK: - SwapViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.dataStore?.baseCurrencies = Array(Set(currencies.compactMap({ $0.baseCurrency })))
                self?.dataStore?.termCurrencies = Array(Set(currencies.compactMap({ $0.termCurrency })))
                self?.dataStore?.baseAndTermCurrencies = currencies.compactMap({ [$0.baseCurrency, $0.termCurrency] })
                
                // TODO: REMOVE THIS. FOR REAL. THIS IS FOR TESTING.
                self?.dataStore?.selectedBaseCurrency = self?.dataStore?.baseAndTermCurrencies[0][0]
                self?.dataStore?.selectedTermCurrency = self?.dataStore?.baseAndTermCurrencies[0][1]
                
                self?.presenter?.presentData(actionResponse: .init(item:
                                                                    Models.Item(selectedBaseCurrency: self?.dataStore?.selectedBaseCurrency,
                                                                                selectedBaseCurrencyIcon: self?.dataStore?.currencies.first(where: {
                    $0.code == self?.dataStore?.selectedBaseCurrency?.lowercased() ?? ""
                })?.imageSquareBackground,
                                                                                selectedTermCurrency: self?.dataStore?.selectedTermCurrency,
                                                                                selectedTermCurrencyIcon: self?.dataStore?.currencies.first(where: {
                    $0.code == self?.dataStore?.selectedTermCurrency?.lowercased() ?? ""
                })?.imageSquareBackground)))
                
            case .failure(let error):
                dump(error)
                
            }
        }
    }
    
    func setAmount(viewAction: SwapModels.Amounts.ViewAction) {
        dataStore?.fromFiatAmount = SwapPresenter.currencyInputFormatting(numberString: viewAction.fromFiatAmount).1
        dataStore?.fromCryptoAmount = SwapPresenter.currencyInputFormatting(numberString: viewAction.fromCryptoAmount).1
        dataStore?.toFiatAmount = SwapPresenter.currencyInputFormatting(numberString: viewAction.toFiatAmount).1
        dataStore?.toCryptoAmount = SwapPresenter.currencyInputFormatting(numberString: viewAction.toCryptoAmount).1
        
        presenter?.presentSetAmount(actionResponse: .init(fromFiatAmount: viewAction.fromFiatAmount,
                                                          fromCryptoAmount: viewAction.fromCryptoAmount,
                                                          toFiatAmount: viewAction.toFiatAmount,
                                                          toCryptoAmount: viewAction.toCryptoAmount))
    }
    
    // MARK: - Aditional helpers
}
