//
//  BillingAddressInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Frames
import UIKit

class BillingAddressInteractor: NSObject, Interactor, BillingAddressViewActions {
    typealias Models = BillingAddressModels

    var presenter: BillingAddressPresenter?
    var dataStore: BillingAddressStore?

    // MARK: - BillingAddressViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: dataStore))
    }
    
    func getPaymentCards(viewAction: BillingAddressModels.PaymentCards.ViewAction) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.presenter?.presentPaymentCards(actionResponse: .init(allPaymentCards: data))
                
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
        guard let number = dataStore?.addCardDataStore?.cardNumber,
              let cvv = dataStore?.addCardDataStore?.cardCVV,
              let month = dataStore?.addCardDataStore?.cardExpDateMonth,
              let year = dataStore?.addCardDataStore?.cardExpDateYear else { return }
        
        let checkoutAPIClient = CheckoutAPIClient(publicKey: "pk_sbox_ees63clhrko6kta6j3cwloebg4#",
                                                  environment: .sandbox) // TODO: Should be updated when we get the prod key.
        
        let cardTokenRequest = CkoCardTokenRequest(number: number,
                                                   expiryMonth: month,
                                                   expiryYear: year,
                                                   cvv: cvv)
        
        checkoutAPIClient.createCardToken(card: cardTokenRequest) { [weak self] result in
            switch result {
            case .success(let response):
                guard let dataStore = self?.dataStore else { return }
                
                let data = AddCardRequestData(token: response.token,
                                              firstName: dataStore.firstName,
                                              lastName: dataStore.lastName,
                                              countryCode: dataStore.country,
                                              state: dataStore.stateProvince,
                                              city: dataStore.city,
                                              zip: dataStore.zipPostal,
                                              address: dataStore.address)
                
                AddCardWorker().execute(requestData: data) { result in
                    switch result {
                    case .success(let data):
                        if let redirectUrl = data.redirectUrl {
                            self?.dataStore?.paymentReference = data.paymentReference
                            
                            self?.presenter?.presentThreeDSecure(actionResponse: .init(url: redirectUrl))
                        } else {
                            self?.dataStore?.paymentstatus = data.status
                            
                            self?.handlePresentSubmit()
                        }
                        
                    case .failure(let error):
                        self?.presenter?.presentError(actionResponse: .init(error: error))
                    }
                }
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func checkThreeDSecureStatus(viewAction: BillingAddressModels.ThreeDSecureStatus.ViewAction) {
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
    
    private func handlePresentSubmit() {
        switch dataStore?.paymentstatus {
        case .captured, .cardVerified:
            presenter?.presentSubmit(actionResponse: .init())
        default:
            break // TODO: Handle error
        }
    }
}
