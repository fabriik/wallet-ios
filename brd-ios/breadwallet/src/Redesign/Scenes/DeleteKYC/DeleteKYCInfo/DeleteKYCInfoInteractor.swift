//
//  DeleteKYCInfoInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class DeleteKYCInfoInteractor: NSObject, Interactor, DeleteKYCInfoViewActions {
    typealias Models = DeleteKYCInfoModels

    var presenter: DeleteKYCInfoPresenter?
    var dataStore: DeleteKYCInfoStore?

    // MARK: - DeleteKYCInfoViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let item = Models.Item(nil)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func toggleTickbox(viewAction: DeleteKYCInfoModels.Tickbox.ViewAction) {
        presenter?.presentToggleTickbox(actionResponse: .init(value: viewAction.value))
    }
    
    // MARK: - Aditional helpers
}
