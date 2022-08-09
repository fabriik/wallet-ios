//
//  AddCardInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Frames
import UIKit

class AddCardInteractor: NSObject, Interactor, AddCardViewActions {
    typealias Models = AddCardModels

    var presenter: AddCardPresenter?
    var dataStore: AddCardStore?

    // MARK: - AddCardViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let months: [String] = (1...12).compactMap { String($0) }
        let year = Calendar.current.component(.year, from: Date())
        let years: [String] = (year...year + 100).compactMap { String($0) }
        
        dataStore?.months = months
        dataStore?.years = years
        
        presenter?.presentData(actionResponse: .init(item: dataStore))
    }
    
    func cardInfoSet(viewAction: AddCardModels.CardInfo.ViewAction) {
        if let index = viewAction.expirationDateIndex {
            var month = dataStore?.months[index.primaryRow] ?? ""
            month = month.count == 1 ? "0\(month)" : month
            let year = dataStore?.years[index.secondaryRow] ?? ""
            dataStore?.cardExpDateString = "\(month)/\(year.dropFirst(2))"
            
            presenter?.presentData(actionResponse: .init(item: dataStore))
        }
        
        if let number = viewAction.number {
            dataStore?.cardNumber = number
        }
        
        if let cvv = viewAction.cvv {
            dataStore?.cardCVV = cvv
        }
        
        validate(viewAction: .init())
    }
    
    func validate(viewAction: AddCardModels.Validate.ViewAction) {
        let isValid = FieldValidator.validate(fields: [dataStore?.cardNumber,
                                                       dataStore?.cardExpDateString,
                                                       dataStore?.cardCVV])
        
        presenter?.presentValidate(actionResponse: .init(isValid: isValid))
    }
    
    func submit(viewAction: AddCardModels.Submit.ViewAction) {
        guard let number = dataStore?.cardNumber,
              let cvv = dataStore?.cardCVV,
              let date = dataStore?.cardExpDateString?.components(separatedBy: "/"),
              let month = date.first,
              let year = date.last else { return }
        
        let checkoutAPIClient = CheckoutAPIClient(
            publicKey: "pk_sbox_ees63clhrko6kta6j3cwloebg4#",
            environment: E.isDebug ? .sandbox : .live)
        
        // Create a CardTokenRequest instance with the phoneNumber and address values.
        let cardTokenRequest = CkoCardTokenRequest(
            number: number,
            expiryMonth: month,
            expiryYear: year,
            cvv: cvv,
            name: "Fabriik Customer")
        
        // Request the card token.
        checkoutAPIClient.createCardToken(card: cardTokenRequest) { [weak self] result in
            switch result {
            case .success(let response):
                AddCardWorker().execute(requestData: AddCardRequestData(token: response.token)) { result in
                    switch result {
                    case .success(let data):
                        self?.presenter?.presentSubmit(actionResponse: .init())
                        
                    case .failure(let error):
                        self?.presenter?.presentError(actionResponse: .init(error: error))
                    }
                }
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func showInfoPopup(viewAction: AddCardModels.InfoPopup.ViewAction) {
        presenter?.presentInfoPopup(actionResponse: .init())
    }
}
