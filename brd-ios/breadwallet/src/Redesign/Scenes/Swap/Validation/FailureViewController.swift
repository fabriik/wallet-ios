// 
//  FailureViewController.swift
//  breadwallet
//
//  Created by Rok on 12/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

// currently not used, but if we need to, we can expand the VC with this protocol instead of enum directly
protocol SimpleMessage {
    var iconName: String { get }
    var title: String { get }
    var description: String { get }
    var firstButtonTitle: String? { get }
    var secondButtonTitle: String? { get }
}

enum FailureReason: SimpleMessage {
    case buy
    case swap
    
    var iconName: String {
        return "failedStatusIcon"
    }
    
    var title: String {
        switch self {
        case .buy:
            return "There was an error while processing your payment"
            
        case .swap:
            return "There was an error while processing your transaction"
        }
    }
    
    var description: String {
        switch self {
        case .buy:
            return "Please contact your card issuer/bank or try again with a different payment method."
            
        case .swap:
            return "Please try swapping again or come back later."
        }
    }
    
    var firstButtonTitle: String? {
        switch self {
        case .buy:
            return "Try a different payment method"
            
        case .swap:
            return "Swap again"
        }
    }
    
    var secondButtonTitle: String? {
        switch self {
        case .buy:
            return "Contact support"
            
        case .swap:
            return "Back to Home"
        }
    }
}

import UIKit

extension Scenes {
    static var Failure = FailureViewController.self
}

class FailureViewController: BaseInfoViewController {
    
    var failure: FailureReason? {
        didSet {
            prepareData()
        }
    }
    override var imageName: String? { return failure?.iconName }
    override var titleText: String? { return failure?.title }
    override var descriptionText: String? { return failure?.description }
    override var buttonViewModels: [ButtonViewModel] {
        return [
            .init(title: failure?.firstButtonTitle),
            .init(title: failure?.secondButtonTitle)
        ]
    }

    override var buttonCallbacks: [(() -> Void)] {
        return [
            first,
            second
        ]
    }

    var firstCallback: (() -> Void)?
    var secondCallback: (() -> Void)?
    
    func first() {
        firstCallback?()
    }

    func second() {
        secondCallback?()
    }
}
