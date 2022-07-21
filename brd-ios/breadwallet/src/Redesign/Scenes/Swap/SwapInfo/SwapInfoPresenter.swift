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
        guard let item = actionResponse.item as? Models.Item else { return }
        
        let sections: [Models.Section] = [
            .image,
            .title,
            .description
        ]
        
        // TODO: Localize and update it with selected swaping assets
        let sectionRows: [Models.Section: [Any]] =
        [
            .image: [ ImageViewModel.imageName("swapInfo") ],
            .title: [ LabelViewModel.text("Swapping \(item.from)/\(item.to)") ],
            .description: [ LabelViewModel.text("Your \(item.to) is estimated to arrive in 30 minutes. You can continue to use your wallet. We'll let you know when your swap has finished.") ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - SwapInfoActionResponses

    // MARK: - Additional Helpers

}
