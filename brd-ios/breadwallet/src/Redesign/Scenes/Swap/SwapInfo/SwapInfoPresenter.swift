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
            .description: [ LabelViewModel.text("Your BTC is estimated to arrive in 30 minutes. You can continue to use your wallet. We'll let you know when your swap has finished.") ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - SwapInfoActionResponses

    // MARK: - Additional Helpers

}
