// 
//  SwapCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

class SwapCoordinator: BaseCoordinator, SwapRoutes {
    // MARK: - ProfileRoutes
    
    override func start() {
        open(scene: Scenes.Swap)
    }
    
    override func goBack() {
        parentCoordinator?.childDidFinish(child: self)
        navigationController.dismiss(animated: true)
    }
    
    func showAssetSelector(selected: ((Any?) -> Void)?) {
        let nvc = RootNavigationController()
        let coordinator = AssetSelectionCoordinator(navigationController: nvc)
        coordinator.start()
        coordinator.parentCoordinator = self
        nvc.modalPresentationStyle = .formSheet
        (nvc.topViewController as? AssetSelectionViewController)?.itemSelected = selected
        childCoordinators.append(coordinator)
        navigationController.present(nvc, animated: true)
    }
    
    // MARK: - Aditional helpers
    
}
