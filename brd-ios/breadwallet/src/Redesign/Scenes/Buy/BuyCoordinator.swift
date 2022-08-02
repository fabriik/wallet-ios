// 
//  BuyCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import AVFoundation
import UIKit

class BuyCoordinator: BaseCoordinator, BillingAddressRoutes { // TODO: Routes should be updated
    override func start() {
        open(scene: Scenes.BillingAddress)
    }
    
    func showCountrySelector(selected: ((CountryResponseData?) -> Void)?) {
        let nvc = RootNavigationController()
        let coordinator = ItemSelectionCoordinator(navigationController: nvc)
        coordinator.start()
        coordinator.parentCoordinator = self
        nvc.modalPresentationStyle = .formSheet
        (nvc.topViewController as? ItemSelectionViewController)?.itemSelected = selected
        childCoordinators.append(coordinator)
        navigationController.present(nvc, animated: true)
    }
    
    func dismissFlow() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(child: self)
    }
    
    @objc func popFlow(sender: UIBarButtonItem) {
        if navigationController.children.count == 1 {
            dismissFlow()
        }
        
        navigationController.popToRootViewController(animated: true)
    }
}
