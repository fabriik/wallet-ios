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
        let data = SwapDetailsRequestData(exchangeId: dataStore?.itemId)
        
        SwapDetailsWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.presentData(actionResponse: .init(item: data))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }

    // MARK: - SwapDetailsViewActions

    // MARK: - Aditional helpers
}
