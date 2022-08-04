//
//  KYCBasicPresenter.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//
//

import UIKit

final class KYCBasicPresenter: NSObject, Presenter, KYCBasicActionResponses {
    typealias Models = KYCBasicModels

    weak var viewController: KYCBasicViewController?

    // MARK: - KYCBasicActionResponses

    // MARK: - Additional Helpers
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        let sections: [Models.Section] = [
            .name,
            .country,
            .birthdate,
            .confirm
        ]
        
        let dateViewModel: DateViewModel
        let title: LabelViewModel? = .text("Date of birth")
        
        if let date = item.birthdate {
            let components = Calendar.current.dateComponents([.day, .year, .month], from: date)
            let dateFormat = "%02d"
            guard let month = components.month,
                  let day = components.day,
                  let year = components.year else { return }
            
            dateViewModel = DateViewModel(date: date,
                                          title: title,
                                          month: .init(value: String(format: dateFormat, month)),
                                          day: .init(value: String(format: dateFormat, day)),
                                          year: .init(value: "\(year)"))
        } else {
            dateViewModel = DateViewModel(date: nil,
                                          title: title,
                                          month: .init(title: "MM"),
                                          day: .init(title: "DD"),
                                          year: .init(title: "YYYY"))
        }
        
        let sectionRows: [Models.Section: [Any]] = [
            .name: [
                DoubleHorizontalTextboxViewModel(primaryTitle: .text("Write your name as it appears on your ID"),
                                                 primary: .init(title: "First Name", value: item.firstName),
                                                 secondary: .init(title: "Last Name", value: item.lastName))
            ],
            .country: [
                TextFieldModel(title: "Country",
                               value: item.countryFullName,
                               trailing: .imageName("chevrondown"))
            ],
            .birthdate: [
                dateViewModel
            ],
            .confirm: [
                ButtonViewModel(title: "Confirm")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentCountry(actionResponse: KYCBasicModels.SelectCountry.ActionResponse) {
        guard let countries = actionResponse.countries else { return }
        viewController?.displayCountry(responseDisplay: .init(countries: countries))
    }
    
    func presentValidate(actionResponse: KYCBasicModels.Validate.ActionResponse) {
        viewController?.displayValidate(responseDisplay: .init(isValid: actionResponse.isValid))
    }
    
    func presentSubmit(actionResponse: KYCBasicModels.Submit.ActionResponse) {
        viewController?.displaySubmit(responseDisplay: .init())
    }
}
