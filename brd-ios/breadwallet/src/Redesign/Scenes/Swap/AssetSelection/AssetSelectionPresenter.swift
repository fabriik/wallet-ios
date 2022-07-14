//
//  AssetSelectionPresenter.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

final class AssetSelectionPresenter: NSObject, Presenter, AssetSelectionActionResponses {
    typealias Models = AssetSelectionModels

    weak var viewController: AssetSelectionViewController?

    // MARK: - AssetSelectionActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item else { return }
        
        let sections = [Models.Sections.items]
        
        let sectionRows = [
            Models.Sections.items: item
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - Additional Helpers

}
