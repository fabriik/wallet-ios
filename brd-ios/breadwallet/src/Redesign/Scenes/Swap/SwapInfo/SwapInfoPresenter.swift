//
//  SwapInfoPresenter.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

final class SwapInfoPresenter: NSObject, Presenter, SwapInfoActionResponses {
    
    typealias Models = SwapInfoModels

    weak var viewController: SwapInfoViewController?
    
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let sections: [Models.Section] = [
            .image,
            .title,
            .description
        ]
        
        // TODO: Localize and update it with selected swaping assets
        let sectionRows: [Models.Section: [Any]] =
        [
            .image: [ ImageViewModel.imageName("swapInfo") ],
            .title: [ LabelViewModel.text("Swapping BSV/BTC") ],
            .description: [ LabelViewModel.text("In approximately 30 minutes or less your BTC will arrive. You can continue to use you wallet safely, we will notify you when it’s done.") ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - SwapInfoActionResponses

    // MARK: - Additional Helpers

}
