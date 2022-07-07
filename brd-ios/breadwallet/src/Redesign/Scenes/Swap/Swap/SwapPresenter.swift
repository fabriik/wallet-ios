//
//  SwapPresenter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class SwapPresenter: NSObject, Presenter, SwapActionResponses {
    typealias Models = SwapModels
    
    weak var viewController: SwapViewController?
    
    // MARK: - SwapActionResponses
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let sections: [Models.Sections] = [
            .swapCard,
            .amountSegment,
            .confirm
        ]
        
        let sectionRows: [Models.Sections: [Any]] = [
            .swapCard: [
                // TODO: Populate
                MainSwapViewModel(fromFiatAmount: 0, fromFiatAmountString: "",
                                  fromCryptoAmount: 0, fromCryptoAmountString: "",
                                  toFiatAmount: 0, toFiatAmountString: "",
                                  toCryptoAmount: 0, toCryptoAmountString: "")
            ],
            .amountSegment: [
                SegmentControlViewModel(selectedIndex: nil)
            ],
            .confirm: [
                // TODO: Localize
                ButtonViewModel(title: "Confirm")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentSetAmount(actionResponse: SwapModels.Amounts.ActionResponse) {
        var fieldValidationIsAllowed = [String?: Bool]()
        
        let fromFiatAmount = SwapPresenter.currencyInputFormatting(numberString: actionResponse.fromFiatAmount)
        let fromCryptoAmount = SwapPresenter.currencyInputFormatting(numberString: actionResponse.fromCryptoAmount)
        let toFiatAmount = SwapPresenter.currencyInputFormatting(numberString: actionResponse.toFiatAmount)
        let toCryptoAmount = SwapPresenter.currencyInputFormatting(numberString: actionResponse.toCryptoAmount)
        
        fieldValidationIsAllowed["fromFiatAmount"] = fromFiatAmount.1.floatValue > 0
        fieldValidationIsAllowed["fromCryptoAmount"] = fromCryptoAmount.1.floatValue > 0
        fieldValidationIsAllowed["toFiatAmount"] = toFiatAmount.1.floatValue > 0
        fieldValidationIsAllowed["toCryptoAmount"] = toCryptoAmount.1.floatValue > 0
        
        let isValid = fieldValidationIsAllowed.values.contains(where: { $0 == true }) == true
        
        viewController?
            .displaySetAmount(responseDisplay:
                    .init(amounts: .init(fromFiatAmount: fromFiatAmount.1,
                                         fromFiatAmountString: fromFiatAmount.0 == "0" ? nil : fromFiatAmount.0,
                                         fromCryptoAmount: fromCryptoAmount.1,
                                         fromCryptoAmountString: fromCryptoAmount.0 == "0" ? nil : fromCryptoAmount.0,
                                         toFiatAmount: toFiatAmount.1,
                                         toFiatAmountString: toFiatAmount.0 == "0" ? nil : toFiatAmount.0,
                                         toCryptoAmount: toCryptoAmount.1,
                                         toCryptoAmountString: toCryptoAmount.0 == "0" ? nil : toCryptoAmount.0),
                          shouldEnableConfirm: isValid))
    }
    
    // MARK: - Additional Helpers
    
    static func currencyInputFormatting(numberString: String?) -> (String, NSNumber) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 10
        
        let regex = try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        let numberString = regex?.stringByReplacingMatches(in: numberString ?? "",
                                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                           range: NSRange(location: 0,
                                                                          length: numberString?.count ?? 0),
                                                           withTemplate: "") ?? ""
        
        let double = (numberString as NSString).doubleValue
        let number = NSNumber(value: (double / 100))
        
        return (formatter.string(from: number) ?? "", number)
    }
}
