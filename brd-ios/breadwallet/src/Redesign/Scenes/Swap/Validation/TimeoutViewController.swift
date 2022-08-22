// 
//  TimeoutViewController.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 22/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let Timeout = TimeoutViewController.self
}

class TimeoutViewController: BaseInfoViewController {
    override var imageName: String? { return "timeoutStatusIcon" }
    override var titleText: String? { return "Payment verification timeout" }
    override var descriptionText: String? { return "The payment has expired due to inactivity. Please try again with the same card, or use a different card." }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: "Try again")
        ]
    }

    override var buttonCallbacks: [(() -> Void)] {
        return [
            first
        ]
    }

    var firstCallback: (() -> Void)?
    
    func first() {
        firstCallback?()
    }
}
