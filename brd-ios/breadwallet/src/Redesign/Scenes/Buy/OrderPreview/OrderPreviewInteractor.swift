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
        
        getPaymentStatus(reference: reference) { [weak self] result in
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
    
    func showCvvInfoPopup(viewAction: OrderPreviewModels.CvvInfoPopup.ViewAction) {
        presenter?.presentCvvInfoPopup(actionResponse: .init())
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
            case .success(let exchangeData):
                self?.getPaymentStatus(reference: exchangeData?.paymentReference ?? "", completion: { result in
                    switch result {
                    case .success(let paymentStatusData):
                        self?.dataStore?.paymentstatus = paymentStatusData?.status
                        
                        if let redirectUrlString = exchangeData?.redirectUrl, let redirectUrl = URL(string: redirectUrlString) {
                            TransferManager.shared.reload()
                            
                            self?.dataStore?.paymentReference = exchangeData?.paymentReference
                            
                            self?.presenter?.presentThreeDSecure(actionResponse: .init(url: redirectUrl))
                        } else {
                            self?.handlePresentSubmit()
                        }
                        
                    case .failure(let error):
                        self?.presenter?.presentError(actionResponse: .init(error: error))
                    }
                })
                
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
    
    func showTermsAndConditions(viewAction: OrderPreviewModels.TermsAndConditions.ViewAction) {
        guard let url = URL(string: C.termsAndConditions) else { return }
        presenter?.presentTermsAndConditions(actionResponse: .init(url: url))
    }
    
    // TODO: add rate refreshing logic!
    
    // MARK: - Aditional helpers
    
    private func getPaymentStatus(reference: String, completion: @escaping (Result<AddCard?, Error>) -> Void) {
        PaymentStatusWorker().execute(requestData: PaymentStatusRequestData(reference: reference)) { result in
            completion(result)
        }
    }
    
    private func handlePresentSubmit() {
        if C.successfullPayment.contains(where: { $0 == dataStore?.paymentstatus }) {
            presenter?.presentSubmit(actionResponse: .init(paymentReference: dataStore?.paymentReference ?? ""))
        } else {
            presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: L10n.Buy.paymentFailed)))
        }
    }
}
