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
        guard let reference = dataStore?.paymentReference else {
            let item: Models.Item = (to: dataStore?.to, from: dataStore?.from, quote: dataStore?.quote, networkFee: dataStore?.networkFee, card: dataStore?.card)
            presenter?.presentData(actionResponse: .init(item: item))
            return
        }
        
        PaymentStatusWorker().execute(requestData: PaymentStatusRequestData(reference: reference)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.paymentstatus = data?.status
                
                self?.handlePresentSubmit()
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
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
                self?.dataStore?.paymentstatus = data?.status
                if let redirectUrlString = data?.redirectUrl, let redirectUrl = URL(string: redirectUrlString) {
                    self?.dataStore?.paymentReference = data?.paymentReference
                    
                    self?.presenter?.presentThreeDSecure(actionResponse: .init(url: redirectUrl))
                } else {
                    self?.handlePresentSubmit()
                }
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func updateCvv(viewAction: OrderPreviewModels.CvvValidation.ViewAction) {
        dataStore?.cvv = viewAction.cvv
        
        presenter?.presentCvv(actionResponse: .init(cvv: dataStore?.cvv))
    }

    // TODO: Merge the logic with Billing Details. They are the same things. The whole card and 3D secure flow should be reusable.
    private func handlePresentSubmit() {
        switch dataStore?.paymentstatus {
        case .captured, .cardVerified:
            presenter?.presentSubmit(actionResponse: .init(paymentReference: dataStore?.paymentReference ?? ""))
            
        default:
            presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: "Payment failed")))
        }
    }

    // TODO: add rate refreshing logic!
    // MARK: - Aditional helpers
}
