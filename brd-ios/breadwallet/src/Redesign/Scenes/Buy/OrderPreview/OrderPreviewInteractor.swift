//
//  OrderPreviewInteractor.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class OrderPreviewInteractor: NSObject, Interactor, OrderPreviewViewActions {
    typealias Models = OrderPreviewModels

    var presenter: OrderPreviewPresenter?
    var dataStore: OrderPreviewStore?
    
    // MARK: - OrderPreviewViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: nil))
    }

    // MARK: - Aditional helpers
}
