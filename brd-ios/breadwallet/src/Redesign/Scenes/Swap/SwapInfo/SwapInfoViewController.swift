// 
//  SwapInfoViewController.swift
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

class SwapInfoViewController: BaseInfoViewController {
    
    typealias Item = (from: String, to: String)
    
    override var imageName: String? { return "swapInfo" }
    override var titleText: String? { return "Swapping \((dataStore?.item as? Item)?.from ?? "")/\((dataStore?.item as? Item)?.to ?? "")" }
    override var descriptionText: String? {
        let to = (dataStore?.item as? Item)?.to ?? ""
        
        return "Your \(to) is estimated to arrive in 30 minutes. You can continue to use your wallet. We'll let you know when your swap has finished."
    }
    
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: "Back to Home"),
            .init(title: "Swap details")
        ]
    }
    
    override var buttonCallbacks: [(() -> Void)] {
        return [
            homeTapped,
            ExchangeDetailsTapped
        ]
    }
    
    func homeTapped() {
        coordinator?.goBack()
    }
    
    func ExchangeDetailsTapped() {
        guard let itemId = dataStore?.itemId else { return }
        (coordinator as? SwapCoordinator)?.showExchangeDetails(exchangeId: itemId)
    }
}
