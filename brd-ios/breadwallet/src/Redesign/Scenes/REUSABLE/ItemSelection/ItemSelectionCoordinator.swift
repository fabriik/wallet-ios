//
//  ItemSelectionCoordinator.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

class ItemSelectionCoordinator: BaseCoordinator, ItemSelectionRoutes {
    // MARK: - ItemSelectionRoutes
    override func start() {
        open(scene: Scenes.ItemSelection)
    }
    
    // MARK: - Aditional helpers
    
    func dismissFlow() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(child: self)
    }
}
