// 
//  SwapCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class SwapCoordinator: BaseCoordinator, SwapRoutes, AssetSelectionDisplayable {
    // MARK: - ProfileRoutes
    
    override func start() {
        open(scene: Scenes.Swap)
    }
    
    override func goBack() {
        parentCoordinator?.childDidFinish(child: self)
        navigationController.dismiss(animated: true)
    }
    
    func showPinInput(keyStore: KeyStore?, callback: ((_ pin: String?) -> Void)?) {
        guard let keyStore = keyStore else { fatalError("No key store") }
        
        let vc = LoginViewController(for: .confirmation,
                                     keyMaster: keyStore,
                                     shouldDisableBiometrics: true)
        
        let nvc = RootNavigationController(rootViewController: vc)
        vc.confirmationCallback = { pin in
            callback?(pin)
            nvc.dismiss(animated: true)
        }
        nvc.modalPresentationStyle = .fullScreen
        navigationController.show(nvc, sender: nil)
    }
    
    func showSwapInfo(from: String, to: String, exchangeId: String) {
        open(scene: SwapInfoViewController.self) { vc in
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.item = (from: from, to: to)
            vc.prepareData()
        }
    }
    
    func showSwapDetails(exchangeId: String) {
        open(scene: SwapDetailsViewController.self) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.transactionType = .swapTransaction
            vc.prepareData()
        }
    }
    
    func showFailure() {
        open(scene: Scenes.Failure) { vc in
            vc.failure = FailureReason.swap
            vc.firstCallback = { [weak self] in
                self?.navigationController.popToRootViewController(animated: true)
            }
            
            vc.secondCallback = { [weak self] in
                self?.navigationController.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Aditional helpers
}
