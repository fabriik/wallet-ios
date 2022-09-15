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
    
    func showPinInput(keyStore: KeyStore?, callback: ((_ pin: String?) -> Void)?) {
        guard let keyStore = keyStore else {
            fatalError("No key store")
        }
        
        let vc = LoginViewController(for: .confirmation,
                                     keyMaster: keyStore,
                                     shouldDisableBiometrics: true)
        let nvc = RootNavigationController(rootViewController: vc)
        
        vc.confirmationCallback = { [weak self] pin in
            nvc.dismiss(animated: true)
            callback?(pin)
            
            if pin == nil {
                self?.showMessage(with: SwapErrors.pinConfirmation)
            }
        }
        
        nvc.modalPresentationStyle = .fullScreen
        navigationController.show(nvc, sender: nil)
    }
    
    func showSwapInfo(from: String, to: String, exchangeId: String) {
        open(scene: SwapInfoViewController.self) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.item = (from: from, to: to)
            vc.prepareData()
        }
    }
    
    func showSwapDetails(exchangeId: String) {
        open(scene: ExchangeDetailsViewController.self) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.transactionType = .swapTransaction
            vc.prepareData()
        }
    }
    
    func showFailure() {
        open(scene: Scenes.Failure) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.failure = FailureReason.swap
            vc.firstCallback = { [weak self] in
                self?.popToRoot()
            }
            
            vc.secondCallback = { [weak self] in
                self?.goBack(completion: {})
            }
        }
    }
    
    // MARK: - Aditional helpers
}
