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
        presenter?.presentData(actionResponse: .init(item: Models.Item()))
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
