//
//  SwapDetailsPresenter.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

final class SwapDetailsPresenter: NSObject, Presenter, SwapDetailsActionResponses {
    typealias Models = SwapDetailsModels

    weak var viewController: SwapDetailsViewController?

    // MARK: - SwapDetailsActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        let sections = [
            Models.Section.header,
            Models.Section.order,
            Models.Section.fromCurrency,
            Models.Section.toCurrency,
            Models.Section.transactionID
        ]
        
        let image = TokenImageSquareBackground(code: "timelapse", color: .red).renderedImage ?? UIImage()
        
        // TODO: Localize and update
        let sectionRows = [
            Models.Section.header: [
                AssetViewModel(icon: image, title: "Pending")
            ],
            
            Models.Section.order: [
                OrderViewModel(title: "Fabriik Order ID", value: "13rXEZoh5NFj4q9aasdfkLp2...", imageName: "copy")
            ],
            
            Models.Section.fromCurrency: [
                AssetViewModel(icon: image, title: "From BSV", topRightText: "50 / $2,859.00 USD")
            ],
            
            Models.Section.toCurrency: [
                AssetViewModel(icon: image, title: "To BTC", topRightText: "0.095 / $2,857.48 USD")
            ],
            
            Models.Section.transactionID: [
                OrderViewModel(title: "Bitcoin BSV Transaction ID", value: "39246726y89e1ruhut7e3xy78e1xg17gx71x2xuih7y7y8y8y8y2782yx78x8382643j21", imageName: "copy")
            ]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }

    // MARK: - Additional Helpers

}
