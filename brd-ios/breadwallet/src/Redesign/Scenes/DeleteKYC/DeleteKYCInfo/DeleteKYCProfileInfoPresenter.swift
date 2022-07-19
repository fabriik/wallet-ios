//
//  DeleteKYCProfileInfoPresenter.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

final class DeleteKYCProfileInfoPresenter: NSObject, Presenter, DeleteKYCProfileInfoActionResponses {
    typealias Models = DeleteKYCProfileInfoModels

    weak var viewController: DeleteKYCProfileInfoViewController?

    // MARK: - DeleteKYCProfileInfoActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        var checklistTitle: LabelViewModel { return .text("What does this mean?") }
        var checkmarks: [ChecklistItemViewModel] { return [
            .init(title: .text("-You will no longer be able to use your email to sign in into Fabriik Wallet"), image: nil),
            .init(title: .text("-You will no longer be able to user your KYC and registration status"), image: nil),
            .init(title: .text("-Your private keys are still yours, keep your security phrase in a safe place in case you need to restore your wallet."), image: nil)
            ]
        }
        
        let sections: [Models.Section] = [
            .title,
            .checkmarks,
            .tickbox,
            .confirm
        ]
        
        let sectionRows: [Models.Section: [Any]] = [
            .title: [
                checklistTitle
            ],
            .checkmarks: checkmarks,
            .tickbox: [
                TickboxItemViewModel(title: .text("I understand that the only way to recover my wallet is by entering my recovery phrase"))
            ],
            .confirm: [
                ButtonViewModel(title: "Continue", enabled: false)
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentToggleTickbox(actionResponse: DeleteKYCProfileInfoModels.Tickbox.ActionResponse) {
        viewController?.displayToggleTickbox(responseDisplay: .init(model: .init(title: "Continue", enabled: actionResponse.value)))
    }
    
    // MARK: - Additional Helpers
}
