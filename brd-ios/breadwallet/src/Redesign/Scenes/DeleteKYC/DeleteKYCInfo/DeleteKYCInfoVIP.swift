//
//  DeleteKYCInfoVIP.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 19/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let DeleteKYCInfo = DeleteKYCInfoViewController.self
}

protocol DeleteKYCInfoViewActions: BaseViewActions, FetchViewActions {
    func toggleTickbox(viewAction: DeleteKYCInfoModels.Tickbox.ViewAction)
}

protocol DeleteKYCInfoActionResponses: BaseActionResponses, FetchActionResponses {
    func presentToggleTickbox(actionResponse: DeleteKYCInfoModels.Tickbox.ActionResponse)
}

protocol DeleteKYCInfoResponseDisplays: AnyObject, BaseResponseDisplays, FetchResponseDisplays {
    func displayToggleTickbox(responseDisplay: DeleteKYCInfoModels.Tickbox.ResponseDisplay)
}

protocol DeleteKYCInfoDataStore: BaseDataStore, FetchDataStore {
}

protocol DeleteKYCInfoDataPassing {
    var dataStore: DeleteKYCInfoDataStore? { get }
}

protocol DeleteKYCInfoRoutes: CoordinatableRoutes {
}
