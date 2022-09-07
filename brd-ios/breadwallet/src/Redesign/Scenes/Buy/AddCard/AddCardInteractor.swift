//
//  AddCardInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 03/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

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
            
            let date = dataStore?.cardExpDateString?.components(separatedBy: "/")
            dataStore?.cardExpDateMonth = date?.first
            dataStore?.cardExpDateYear = date?.last
        }
        
        if let number = viewAction.number {
            dataStore?.cardNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        }
        
        if let cvv = viewAction.cvv {
            dataStore?.cardCVV = cvv
        }
        
        presenter?.presentCardInfo(actionResponse: .init(dataStore: dataStore))
        
        validate(viewAction: .init())
    }
    
    func validate(viewAction: AddCardModels.Validate.ViewAction) {
        let isValidInfo = FieldValidator.validate(fields: [dataStore?.cardNumber,
                                                           dataStore?.cardExpDateString])
        let isValidCVV = FieldValidator.validate(CVV: dataStore?.cardCVV ?? "")
        
        presenter?.presentValidate(actionResponse: .init(isValid: isValidInfo && isValidCVV))
    }
    
    func submit(viewAction: AddCardModels.Submit.ViewAction) {
        // FETCH ALL ADDED CARDS AND DELETE IF NEEDED. WILL BE USED. 
        /*
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            switch result {
            case .success(let data):
                for d in data {
                    DeleteCardWorker().execute(requestData: DeleteCardRequestData(instrumentId: d.id)) { [weak self] result in
                        switch result {
                        case .success(let data):
                            print(data)
                            
                        case .failure(let error):
                            self?.presenter?.presentError(actionResponse: .init(error: error))
                        }
                    }
                }
            
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        */
        
        presenter?.presentSubmit(actionResponse: .init())
    }
    
    func showCvvInfoPopup(viewAction: AddCardModels.CvvInfoPopup.ViewAction) {
        presenter?.presentCvvInfoPopup(actionResponse: .init())
    }
}
