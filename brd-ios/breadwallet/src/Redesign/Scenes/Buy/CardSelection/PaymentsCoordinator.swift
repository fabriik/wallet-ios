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
    func showPaymentsActionSheet(okButtonTitle: String,
                           cancelButtonTitle: String,
                           handler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: okButtonTitle, style: .destructive, handler: { _ in
            handler()
        }))
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil))
        
        navigationController.present(alert, animated: true, completion: nil)
    }
}
