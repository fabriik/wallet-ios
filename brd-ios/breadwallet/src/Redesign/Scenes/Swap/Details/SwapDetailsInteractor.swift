//
//  SwapDetailsInteractor.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

class SwapDetailsInteractor: NSObject, Interactor, SwapDetailsViewActions {
    typealias Models = SwapDetailsModels

    var presenter: SwapDetailsPresenter?
    var dataStore: SwapDetailsStore?
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: nil))
    }

    // MARK: - SwapDetailsViewActions

    // MARK: - Aditional helpers
}
