//
//  BillingAddressInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class BillingAddressInteractor: NSObject, Interactor, BillingAddressViewActions {
    typealias Models = BillingAddressModels

    var presenter: BillingAddressPresenter?
    var dataStore: BillingAddressStore?

    // MARK: - BillingAddressViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let reference = dataStore?.paymentReference else {
            presenter?.presentData(actionResponse: .init(item: dataStore))
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
    
    func getPaymentCards(viewAction: BillingAddressModels.PaymentCards.ViewAction) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.presenter?.presentPaymentCards(actionResponse: .init(allPaymentCards: data?.reversed()))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func stateProvinceSet(viewAction: BillingAddressModels.StateProvince.ViewAction) {
        dataStore?.stateProvince = viewAction.stateProvince
        
        validate(viewAction: .init())
    }
    
    func addressSet(viewAction: BillingAddressModels.Address.ViewAction) {
        dataStore?.address = viewAction.address
        
        validate(viewAction: .init())
    }
    
    func nameSet(viewAction: BillingAddressModels.Name.ViewAction) {
        dataStore?.firstName = viewAction.first
        dataStore?.lastName = viewAction.last
        
        validate(viewAction: .init())
    }
    
    func cityAndZipPostalSet(viewAction: BillingAddressModels.CityAndZipPostal.ViewAction) {
        dataStore?.city = viewAction.city
        dataStore?.zipPostal = viewAction.zipPostal
        
        validate(viewAction: .init())
    }
    
    func pickCountry(viewAction: BillingAddressModels.SelectCountry.ViewAction) {
        guard viewAction.code == nil else {
            dataStore?.country = viewAction.code
            dataStore?.countryFullName = viewAction.countryFullName
            presenter?.presentData(actionResponse: .init(item: dataStore))
            validate(viewAction: .init())
            
            return
        }
        
        let data = CountriesRequestData()
        CountriesWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.presenter?.presentCountry(actionResponse: .init(countries: data))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func validate(viewAction: BillingAddressModels.Validate.ViewAction) {
        let isValid = FieldValidator.validate(fields: [dataStore?.firstName,
                                                       dataStore?.lastName,
                                                       dataStore?.country,
                                                       dataStore?.stateProvince,
                                                       dataStore?.city,
                                                       dataStore?.zipPostal,
                                                       dataStore?.address])
        
        presenter?.presentValidate(actionResponse: .init(isValid: isValid))
    }
    
    func submit(viewAction: BillingAddressModels.Submit.ViewAction) {
        guard let dataStore = dataStore, let checkoutToken = dataStore.checkoutToken?.token else { return }
        
        let data = AddCardRequestData(token: checkoutToken,
                                      firstName: dataStore.firstName,
                                      lastName: dataStore.lastName,
                                      countryCode: dataStore.country,
                                      state: dataStore.stateProvince,
                                      city: dataStore.city,
                                      zip: dataStore.zipPostal,
                                      address: dataStore.address)
        
        AddCardWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let exchangeData):
                self?.getPaymentStatus(reference: exchangeData?.paymentReference ?? "", completion: { result in
                    switch result {
                    case .success(let paymentStatusData):
                        self?.dataStore?.paymentReference = exchangeData?.paymentReference
                        self?.dataStore?.paymentstatus = paymentStatusData?.status
                        
                        if let redirectUrlString = exchangeData?.redirectUrl, let redirectUrl = URL(string: redirectUrlString) {
                            ExchangeManager.shared.reload()
                            
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
    
    // MARK: - Aditional helpers
    
    private func getPaymentStatus(reference: String, completion: @escaping (Result<AddCard?, Error>) -> Void) {
        PaymentStatusWorker().execute(requestData: PaymentStatusRequestData(reference: reference)) { result in
            completion(result)
        }
    }
    
    private func handlePresentSubmit() {
        if C.successfullPayment.contains(where: { $0 == dataStore?.paymentstatus }) {
            presenter?.presentSubmit(actionResponse: .init())
        } else {
            presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: L10n.Buy.paymentFailed)))
        }
    }
}
