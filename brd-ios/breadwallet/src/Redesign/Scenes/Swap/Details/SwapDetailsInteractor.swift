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
    
    // MARK: - SwapDetailsViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let data = SwapDetailsRequestData(exchangeId: dataStore?.itemId)
        
        SwapDetailsWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data, let transactionType = self?.dataStore?.transactionType else { return }
                let item = SwapDetailsModels.Item(detail: data, type: transactionType)
                self?.presenter?.presentData(actionResponse: .init(item: item))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func copyValue(viewAction: SwapDetailsModels.CopyValue.ViewAction) {
        var value = viewAction.value ?? ""
        UIPasteboard.general.string = value
    }
    
    // MARK: - Aditional helpers
}
