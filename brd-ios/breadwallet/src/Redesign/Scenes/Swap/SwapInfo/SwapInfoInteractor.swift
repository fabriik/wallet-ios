//
//  SwapInfoInteractor.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

class SwapInfoInteractor: NSObject, Interactor, SwapInfoViewActions {
    
    typealias Models = SwapInfoModels

    var presenter: SwapInfoPresenter?
    var dataStore: SwapInfoStore?
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: nil))
    }

    // MARK: - SwapInfoViewActions

    // MARK: - Aditional helpers
}
