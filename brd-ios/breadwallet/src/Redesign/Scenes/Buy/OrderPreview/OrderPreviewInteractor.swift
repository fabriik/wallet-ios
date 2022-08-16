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
    
    func submit(viewAction: OrderPreviewModels.Submit.ViewAction) {
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
                if let redirectUrlString = data.redirectUrl, let redirectUrl = URL(string: redirectUrlString) {
                    self?.dataStore?.paymentReference = data.paymentReference
                    
                    self?.presenter?.presentThreeDSecure(actionResponse: .init(url: redirectUrl))
                } else {
                    self?.dataStore?.paymentstatus = .authorized //  TODO: Fix the default value
                    
                    self?.handlePresentSubmit()
                }
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func updateCvv(viewAction: OrderPreviewModels.CVVValidation.ViewAction) {
        dataStore?.cvv = viewAction.cvv
        
        presenter?.presentCvv(actionResponse: .init(cvv: dataStore?.cvv))
    }
    
    func checkThreeDSecureStatus(viewAction: OrderPreviewModels.ThreeDSecureStatus.ViewAction) {
        PaymentStatusWorker().execute(requestData: PaymentStatusRequestData(reference: dataStore?.paymentReference)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.paymentstatus = data.status
                
                self?.handlePresentSubmit()
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    // TODO: Merge the logic with Billing Details. They are the same things. The whole card and 3D secure flow should be reusable.
    private func handlePresentSubmit() {
        switch dataStore?.paymentstatus {
        case .captured, .cardVerified:
            presenter?.presentSubmit(actionResponse: .init(paymentReference: dataStore?.paymentReference ?? ""))
        default:
            break // TODO: Handle error
        }
    }

    // TODO: add rate refreshing logic!
    // MARK: - Aditional helpers
}
