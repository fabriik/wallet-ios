//
//  DeleteProfileInfoInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class DeleteProfileInfoInteractor: NSObject, Interactor, DeleteProfileInfoViewActions {
    typealias Models = DeleteProfileInfoModels

    var presenter: DeleteProfileInfoPresenter?
    var dataStore: DeleteProfileInfoStore?

    // MARK: - DeleteProfileInfoViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let item = Models.Item(nil)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func toggleTickbox(viewAction: DeleteProfileInfoModels.Tickbox.ViewAction) {
        presenter?.presentToggleTickbox(actionResponse: .init(value: viewAction.value))
    }
    
    // MARK: - Aditional helpers
}
