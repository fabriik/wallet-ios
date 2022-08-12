// 
//  SuccessViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let SwapInfo = SwapInfoViewController.self
}

extension Scenes {
    static let Success = SuccessViewController.self
}

class SuccessViewController: BaseInfoViewController {
    override var imageName: String? { return "statusIcon" }
    override var titleText: String? { return "Your assets are on the way!" }
    override var descriptionText: String? { return "This purchase will appear as ‘Fabriik Wallet’ on your bank statement." }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: "Back to Home"),
            .init(title: "Purchase details")
        ]
    }

    override var buttonCallbacks: [(() -> Void)] {
        return [
            goHome,
            showDetails
        ]
    }

    func goHome() {
        print("first!")
    }

    func showDetails() {
        print("second!")
    }
}
