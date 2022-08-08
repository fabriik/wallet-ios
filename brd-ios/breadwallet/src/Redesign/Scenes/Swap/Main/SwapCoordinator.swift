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
        open(scene: Scenes.Swap)
    }
    
    override func goBack() {
        parentCoordinator?.childDidFinish(child: self)
        navigationController.dismiss(animated: true)
    }
    
    func showAssetSelector(currencies: [Currency]?, supportedCurrencies: [SupportedCurrency]?, selected: ((Any?) -> Void)?) {
        let allCurrencies = CurrencyFileManager().getCurrencyMetaDataFromCache()
        
        let supportedCurrencies = allCurrencies.filter { item in supportedCurrencies?.contains(where: { $0.name.lowercased() == item.code}) ?? false }
        
        let data: [AssetViewModel]? = supportedCurrencies.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code,
//                                  topRightText: HomeScreenAssetViewModel(currency: $0).tokenBalance,
//                                  bottomRightText: HomeScreenAssetViewModel(currency: $0).fiatBalance,
                                  isDisabled: isDisabledAsset(code: $0.code, currencies: currencies) ?? false)
        }
        
        let sortedCurrencies = data?.sorted { !$0.isDisabled && $1.isDisabled }
        
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.AssetSelection,
                    presentationStyle: .formSheet) { vc in
            vc?.dataStore?.items = sortedCurrencies ?? []
            vc?.itemSelected = selected
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
    
    func isDisabledAsset(code: String?, currencies: [Currency]?) -> Bool? {
        guard let assetCode = code?.uppercased() else { return false }
        
        return !(currencies?.contains(where: { $0.code == assetCode}) ?? false)
    }
    
    // MARK: - Aditional helpers
    
}
