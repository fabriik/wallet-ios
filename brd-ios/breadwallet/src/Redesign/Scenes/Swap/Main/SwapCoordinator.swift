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

class SwapCoordinator: BaseCoordinator, SwapRoutes, SwapInfoRoutes {
    // MARK: - ProfileRoutes
    
    override func start() {
        open(scene: Scenes.SwapDetails)
    }
    
    override func goBack() {
        parentCoordinator?.childDidFinish(child: self)
        navigationController.dismiss(animated: true)
    }
    
    func showAssetSelector(currencies: [Currency]?, assets: [String]?, selected: ((Any?) -> Void)?) {
        openModally(coordinator: SwapCoordinator.self, scene: Scenes.AssetSelection) { vc in
            vc?.itemSelected = selected
            vc?.dataStore?.supportedCurrencies = assets ?? []
            vc?.dataStore?.currencies = currencies ?? []
            vc?.prepareData()
        }
    }
    
    func showPinInput(callback: ((_ pin: String?) -> Void)?) {
        guard let keyStore = try? KeyStore.create() else { return }
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
            vc.dataStore?.from = from
            vc.dataStore?.to = to
            vc.prepareData()
        }
    }
    
    func showSwapDetails(exchangeId: String) {
        open(scene: SwapDetailsViewController.self) { vc in
            vc.dataStore?.itemId = exchangeId
            vc.prepareData()
        }
    }
    // MARK: - Aditional helpers
    
}
