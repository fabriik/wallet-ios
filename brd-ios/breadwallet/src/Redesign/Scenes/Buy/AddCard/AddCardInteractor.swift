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
        dataStore?.monthsYears = .init(months: months, years: years)
        
        presenter?.presentData(actionResponse: .init(item: dataStore))
    }
    
    func cardNumberAndCVVSet(viewAction: AddCardModels.CardNumberAndCVV.ViewAction) {
        dataStore?.cardNumber = viewAction.number
        dataStore?.cardCVV = viewAction.cvv

        validate(viewAction: .init())
    }
    
    func cardExpDateSet(viewAction: AddCardModels.CardExpDate.ViewAction) {
        guard let index = viewAction.index else { return }
        
        var month = dataStore?.monthsYears?.months[index.primaryRow] ?? ""
        month = month.count == 1 ? "0\(month)" : month
        let year = dataStore?.monthsYears?.years[index.secondaryRow] ?? ""
        dataStore?.cardExpDateString = "\(month)/\(year.dropFirst(2))"
        
        presenter?.presentData(actionResponse: .init(item: dataStore))
        
        validate(viewAction: .init())
    }
    
    func validate(viewAction: AddCardModels.Validate.ViewAction) {
        let isValid = FieldValidator.validate(fields: [dataStore?.cardNumber,
                                                       dataStore?.cardExpDateString,
                                                       dataStore?.cardCVV])
        
        presenter?.presentValidate(actionResponse: .init(isValid: isValid))
    }
    
    func submit(viewAction: AddCardModels.Submit.ViewAction) {
        presenter?.presentSubmit(actionResponse: .init())
    }
}
