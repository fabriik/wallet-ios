//
//  SwapInfoCoordinator.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 13.7.22.
//
//

import UIKit

class SwapInfoCoordinator: BaseCoordinator, SwapInfoRoutes {
    // MARK: - SwapInfoRoutes
    
    override func goBack() {
        parentCoordinator?.childDidFinish(child: self)
        navigationController.dismiss(animated: true)
    }
    
    func openSwapDetails() {
        open(scene: Scenes.SwapDetails)
    }
    
    // MARK: - Aditional helpers
}
