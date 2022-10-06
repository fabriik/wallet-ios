//
//  PaymentsCoordinator.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.10.22.
//
//

import UIKit

class PaymentsCoordinator: BuyCoordinator, PaymentsRoutes {
    // MARK: - PaymentsRoutes
    override func start() {
        open(scene: Scenes.Payments)
    }
    
    // MARK: - Aditional helpers
}
