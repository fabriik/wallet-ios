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
        guard let dataStore = dataStore else { return }
        let item = Models.Item(from: dataStore.from, to: dataStore.to)

        presenter?.presentData(actionResponse: .init(item: item))
    }

    // MARK: - SwapInfoViewActions

    // MARK: - Aditional helpers
}
