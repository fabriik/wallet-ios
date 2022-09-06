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
        presenter?.presentInfoPopup(actionResponse: .init(isCardFee: viewAction.isCardFee, fee: dataStore?.quote?.buyFee))
    }
    
    func submit(viewAction: OrderPreviewModels.Submit.ViewAction) {
        guard let currency = dataStore?.to?.currency,
              let address = currency.wallet?.defaultReceiveAddress,
              let to = dataStore?.to?.tokenValue,
              let from = dataStore?.from
        else { return }
        
        let total = from + (dataStore?.networkFee?.fiatValue ?? 0) + from * (dataStore?.quote?.buyFee ?? 1) / 100
        let rounded = Double(round(total.doubleValue * 100) / 100)
        let data = SwapRequestData(quoteId: dataStore?.quote?.quoteId,
                                   depositQuantity: Decimal(rounded),
                                   withdrawalQuantity: to,
                                   destination: address,
                                   sourceInstrumentId: dataStore?.card?.id,
                                   nologCvv: dataStore?.cvv?.description)
        
        SwapWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.paymentstatus = data?.status
                if let redirectUrlString = data?.redirectUrl, let redirectUrl = URL(string: redirectUrlString) {
                    TransferManager.shared.reload()
                    
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
    
    func checkTimeOut(viewAction: OrderPreviewModels.ExpirationValidations.ViewAction) {
        let isTimedOut = Date().timeIntervalSince1970 > (dataStore?.quote?.timestamp ?? 0) / 1000
        
        presenter?.presentTimeOut(actionResponse: .init(isTimedOut: isTimedOut))
    }
    
    func updateCvv(viewAction: OrderPreviewModels.CvvValidation.ViewAction) {
        dataStore?.cvv = viewAction.cvv
        
        let isValid = FieldValidator.validate(CVV: dataStore?.cvv ?? "")
        
        presenter?.presentCvv(actionResponse: .init(isValid: isValid))
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
    
    func showTermsAndConditions(viewAction: OrderPreviewModels.TermsAndConditions.ViewAction) {
        guard let url = URL(string: C.termsAndConditions) else { return }
        presenter?.presentTermsAndConditions(actionResponse: .init(url: url))
    }
    
    // TODO: add rate refreshing logic!
    // MARK: - Aditional helpers
}
