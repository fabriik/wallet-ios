//
//  DeleteKYCProfileInfoVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let DeleteKYCProfileInfo = DeleteKYCProfileInfoViewController.self
}

protocol DeleteKYCProfileInfoViewActions: BaseViewActions, FetchViewActions {
    func toggleTickbox(viewAction: DeleteKYCProfileInfoModels.Tickbox.ViewAction)
}

protocol DeleteKYCProfileInfoActionResponses: BaseActionResponses, FetchActionResponses {
    func presentToggleTickbox(actionResponse: DeleteKYCProfileInfoModels.Tickbox.ActionResponse)
}

protocol DeleteKYCProfileInfoResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayToggleTickbox(responseDisplay: DeleteKYCProfileInfoModels.Tickbox.ResponseDisplay)
}

protocol DeleteKYCProfileInfoDataStore: BaseDataStore, FetchDataStore {
}

protocol DeleteKYCProfileInfoDataPassing {
    var dataStore: DeleteKYCProfileInfoDataStore? { get }
}

protocol DeleteKYCProfileInfoRoutes: CoordinatableRoutes {
}
