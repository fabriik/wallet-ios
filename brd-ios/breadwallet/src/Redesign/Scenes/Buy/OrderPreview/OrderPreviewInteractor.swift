//
//  OrderPreviewInteractor.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class OrderPreviewInteractor: NSObject, Interactor, OrderPreviewViewActions {
    typealias Models = OrderPreviewModels

    var presenter: OrderPreviewPresenter?
    var dataStore: OrderPreviewStore?
    
    // MARK: - OrderPreviewViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let item: Models.Item = (to: dataStore?.to, from: dataStore?.from, quote: dataStore?.quote)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func showInfoPopup(viewAction: OrderPreviewModels.InfoPopup.ViewAction) {
        presenter?.presentInfoPopup(actionResponse: .init(isCardFee: viewAction.isCardFee))
    }
    
    func confirm(viewAction: OrderPreviewModels.Confirm.ViewAction) {
        guard let currency = dataStore?.to?.currency,
              let address = dataStore?.address(for: currency)
        else {
            // TODO: handle no wallet error
            return
        }
        
        guard let to = dataStore?.to?.tokenValue,
              let from = dataStore?.from else {
            // TODO: no amounts
            return
        }
        
        let data = SwapRequestData(quoteId: dataStore?.quote?.quoteId,
                                   depositQuantity: from,
                                   withdrawalQuantity: to,
                                   destination: address,
                                   sourceInstrumentId: dataStore?.card?.id,
                                   nologCvv: dataStore?.cvv?.description)
        
        SwapWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.presentConfirm(actionResponse: .init(url: data.redirectUrl))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func updateCvv(viewAction: OrderPreviewModels.CvvValidation.ViewAction) {
        dataStore?.cvv = viewAction.cvv
        
        presenter?.presentCvv(actionResponse: .init(cvv: dataStore?.cvv))
    }

    // TODO: add rate refreshing logic!
    // MARK: - Aditional helpers
}
